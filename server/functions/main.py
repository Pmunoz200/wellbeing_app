from firebase_functions import https_fn
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
import json
from datetime import datetime
import logging
from utils.date_utils import parse_date, normalize_date, time_frame, time_str
import google.generativeai as genai
from utils.prompt_utils import (
    no_logs_user_prompt,
    new_time_frame_user_prompt,
    system_instructions,
    detailed_response_user_prompt,
    system_instructions_without_format,
)

# Initialize the Firebase app
initialize_app()

# Configure logging
logging.basicConfig(level=logging.INFO)

# Initialize Firestore client
firestore_client = firestore.client()


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


def gemini_message(role: str, content: str, date: datetime) -> dict:
    """Create a formatted message for the Gemini model."""
    if role == "user":
        content = f"{time_str(date)}: {content}"
    return {
        "role": role,
        "parts": [content],
    }


def db_message(role: str, content: str, date: datetime) -> dict:
    """Format message for Firestore."""
    return {
        "gemini_message": gemini_message(role, content, date),
        "timestamp": date,
    }


def call_gemini(
    messages,
    user_information,
    temperature=0.7,
    max_output_tokens=500,
    output_format=True,
):
    """Call the Gemini model to generate a response."""
    try:
        # Configure the generation parameters
        gen_config = genai.types.GenerationConfig(
            candidate_count=1,
            max_output_tokens=max_output_tokens,
            temperature=temperature,
            response_mime_type="application/json",
        )

        # Format system instructions with user information
        if output_format:
            sys_instruct = system_instructions.format(user_information=user_information)
        else:
            sys_instruct = system_instructions_without_format

        model = genai.GenerativeModel(
            "gemini-1.5-flash",
            generation_config=gen_config,
            system_instruction=sys_instruct,
        )

        # Generate response from the model
        response = model.generate_content(messages)
        text = response.text

        return text
    except Exception as e:
        logging.error(f"Error in call_gemini: {str(e)}")
        raise


def get_gemini_response(
    db_conversation: list,
    query,
    user_information: dict,
    date: datetime,
    output_format=True,
) -> list:
    """Get a response from the Gemini model and update the conversation."""
    try:
        # Add user query to the conversation
        db_conversation.append(db_message("user", query, date))
        query_messages = [message["gemini_message"] for message in db_conversation]
        response = call_gemini(query_messages, user_information, output_format)
        db_conversation.append(db_message("model", response, date))
        return db_conversation
    except Exception as e:
        logging.error(f"Error in get_gemini_response: {str(e)}")
        raise


def app_conversation(db_conversation: list) -> list:
    """Format conversation for the app."""
    app_messages = []
    for db_message in db_conversation:
        message = db_message["gemini_message"]
        if message["role"] == "model":
            app_message = {
                "role": message["role"],
                "content": message["parts"][0],
            }
            app_messages.append(app_message)
    return app_messages


def update_messages_db(
    doc, db_conversation, uid, date: datetime, messages: list
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
    detailed_doc, content, uid, date: datetime, index: int, container: str
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
            return https_fn.Response("Missing date or uid parameter", status=400)

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
                "Missing uid, query, or date parameter", status=400
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
                "Missing uid, index, container, or date parameter", status=400
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
