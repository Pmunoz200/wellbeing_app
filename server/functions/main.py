from firebase_functions import https_fn
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
import json
from datetime import datetime
import logging

from utils.date_utils import parse_date, normalize_date, time_frame
from utils.prompt_utils import (
    no_logs_user_prompt,
    new_time_frame_user_prompt,
    detailed_response_user_prompt,
)
from utils.gemini_utils import get_gemini_response, app_conversation

# Initialize the Firebase app
initialize_app()

# Configure logging
logging.basicConfig(level=logging.INFO)

# Initialize Firestore client
firestore_client = firestore.client()


# ----------------------------------- Database Functions -----------------------------------
def retrieve_user_information(uid: str) -> dict:
    """Retrieve user information from Firestore."""
    try:
        doc = firestore_client.collection("users").document(uid).get()
        if doc.exists:
            return doc.to_dict()
        return {}
    except Exception as e:
        logging.error(f"Error in retrieve_user_information: {str(e)}")
        raise


def retrieve_messages_document(
    uid: str, date: datetime
) -> google.cloud.firestore.DocumentSnapshot:
    """Retrieve messages document from Firestore for a specific user and date."""
    normalized_date = normalize_date(date)
    try:
        docs = (
            firestore_client.collection("messages")
            .where("uid", "==", uid)
            .where("date", "==", normalized_date)
            .stream()
        )
        doc = next(docs, None)
        return doc
    except Exception as e:
        logging.error(f"Error in retrieve_messages_document: {str(e)}")
        raise


def retrieve_detailed_messages_document(
    uid: str, date: datetime, index: int, container: str
) -> google.cloud.firestore.DocumentSnapshot:
    normalized_date = normalize_date(date)
    try:
        docs = (
            firestore_client.collection("detailed_messages")
            .where("uid", "==", uid)
            .where("date", "==", normalized_date)
            .where("index", "==", index)
            .where("container", "==", container)
            .stream()
        )
        doc = next(docs, None)
        return doc
    except Exception as e:
        logging.error(f"Error in retrieve_detailed_messages_document: {str(e)}")
        raise


def update_messages_db(
    doc: google.cloud.firestore.DocumentSnapshot,
    db_conversation: list,
    uid: str,
    date: datetime,
    messages: list,
) -> str:
    """Update Firestore with the conversation."""
    try:
        if doc is None:
            # Add new document if it doesn't exist
            firestore_client.collection("messages").add(
                {
                    "uid": uid,
                    "date": normalize_date(date),
                    "conversation": db_conversation,
                }
            )
        else:
            # Update existing document
            doc.reference.update({"conversation": messages})
        return "Success"
    except Exception as e:
        logging.error(f"Error in update_db: {str(e)}")
        raise


def update_detailed_messages_db(
    detailed_doc: google.cloud.firestore.DocumentSnapshot,
    content: str,
    uid: str,
    date: datetime,
    index: int,
    container: str,
) -> str:
    """Update Firestore with the conversation."""
    try:
        if detailed_doc is None:
            # Add new document if it doesn't exist
            firestore_client.collection("detailed_messages").add(
                {
                    "uid": uid,
                    "date": normalize_date(date),
                    "index": index,
                    "container": container,
                    "content": content,
                }
            )
        else:
            # Update existing document
            detailed_doc.reference.update({"content": content})
        return "Success"
    except Exception as e:
        logging.error(f"Error in update_detailed_db: {str(e)}")
        raise


@https_fn.on_request()
def get_user_messages_by_date(req: https_fn.Request) -> https_fn.Response:
    """Retrieve user messages by date."""
    try:
        # Parse and validate input parameters
        date_str = req.args.get("date")
        uid = req.args.get("uid")

        if not date_str or not uid:
            return https_fn.Response("Missing date or uid parameter", status=422)

        date_obj = parse_date(date_str)

        # Retrieve messages document and user information
        doc = retrieve_messages_document(uid, date_obj)
        user_information = retrieve_user_information(uid)

        # Check if document exists, if not, create a new conversation
        if doc is None:
            db_conversation = []
        else:
            db_conversation = doc.to_dict().get("conversation", [])

        # Initialize messages if empty
        if len(db_conversation) < 2:
            db_conversation = get_gemini_response(
                db_conversation,
                no_logs_user_prompt,
                user_information,
                date_obj,
            )
            update_status = update_messages_db(
                doc, db_conversation, uid, date_obj, db_conversation
            )

        # Check if the time frame is different
        else:
            last_message = db_conversation[-1]
            last_time = last_message["timestamp"]
            last_time_frame = time_frame(last_time)
            current_time_frame = time_frame(date_obj)

            if last_time_frame != current_time_frame:
                db_conversation = get_gemini_response(
                    db_conversation,
                    new_time_frame_user_prompt,
                    user_information,
                    date_obj,
                )
                update_status = update_messages_db(
                    doc, db_conversation, uid, date_obj, db_conversation
                )

        return https_fn.Response(
            response=json.dumps({"conversation": app_conversation(db_conversation)}),
            status=200,
            mimetype="application/json",
        )

    except ValueError as ve:
        logging.warning(f"Validation error in get_user_messages_by_date: {str(ve)}")
        return https_fn.Response(str(ve), status=400)

    except Exception as e:
        logging.error(f"Error in get_user_messages_by_date: {str(e)}")
        return https_fn.Response(f"Internal server error: {str(e)}", status=500)


@https_fn.on_request()
def get_response(req: https_fn.Request) -> https_fn.Response:
    """Add a message to the Firestore database and get a response."""
    try:
        # Parse and validate input parameters
        uid = req.args.get("uid")
        query = req.args.get("query")
        date_str = req.args.get("date")

        if not uid or not query or not date_str:
            return https_fn.Response(
                "Missing uid, query, or date parameter", status=422
            )

        date_obj = parse_date(date_str)

        # Retrieve messages document and user information
        doc = retrieve_messages_document(uid, date_obj)
        user_information = retrieve_user_information(uid)

        # Check if document exists, if not, create a new conversation
        if doc is None:
            db_conversation = []
        else:
            db_conversation = doc.to_dict().get("conversation", [])

        # Get response from Gemini model and update conversation
        db_conversation = get_gemini_response(
            db_conversation, query, user_information, date_obj
        )

        # Update Firestore with the new conversation
        update_status = update_messages_db(
            doc, db_conversation, uid, date_obj, db_conversation
        )

        return https_fn.Response(
            response=json.dumps({"conversation": app_conversation(db_conversation)}),
            status=200,
            mimetype="application/json",
        )

    except ValueError as ve:
        logging.warning(f"Validation error in get_response: {str(ve)}")
        return https_fn.Response(str(ve), status=400)

    except Exception as e:
        logging.error(f"Error in get_response: {str(e)}")
        return https_fn.Response(f"Internal server error: {str(e)}", status=500)


@https_fn.on_request()
def get_detailed_response(req: https_fn.Request) -> https_fn.Response:
    """Add a message to the Firestore database and get a response."""
    try:
        # Parse and validate input parameters
        uid = req.args.get("uid")
        index = req.args.get("index")
        container = req.args.get("container")
        date_str = req.args.get("date")

        if not uid or not index or not date_str or not container:
            return https_fn.Response(
                "Missing uid, index, container, or date parameter", status=422
            )

        index = int(index)
        date_obj = parse_date(date_str)

        # Retrieve messages document and user information
        detailed_doc = retrieve_detailed_messages_document(
            uid, date_obj, index, container
        )

        content = ""
        if detailed_doc is not None:
            content = detailed_doc.to_dict().get("content", "")

        if detailed_doc is None or content == "":
            doc = retrieve_messages_document(uid, date_obj)
            user_information = retrieve_user_information(uid)

            # Check if document exists, if not, create a new conversation
            if doc is None:
                db_conversation = []
            else:
                db_conversation = doc.to_dict().get("conversation", [])

            db_conversation[: index + 1]
            user_query = detailed_response_user_prompt.format(container=container)

            # Get response from Gemini model and update conversation
            db_conversation = get_gemini_response(
                db_conversation, user_query, user_information, date_obj, False
            )
            content = db_conversation[-1]["gemini_message"]["parts"][0]
            content = json.loads(content)["content"]

            # Update Firestore with the new conversation
            update_status = update_detailed_messages_db(
                detailed_doc,
                content,
                uid,
                date_obj,
                index,
                container,
            )

        return https_fn.Response(
            response=json.dumps({"content": content}),
            status=200,
            mimetype="application/json",
        )

    except ValueError as ve:
        logging.warning(f"Validation error in get_response: {str(ve)}")
        return https_fn.Response(str(ve), status=400)

    except Exception as e:
        logging.error(f"Error in get_detailed_response: {str(e)}")
        return https_fn.Response(f"Internal server error: {str(e)}", status=500)
