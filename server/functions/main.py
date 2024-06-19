from firebase_functions import firestore_fn, https_fn
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
import json
from datetime import datetime
import logging

# Initialize the Firebase app
initialize_app()

# Configure logging
logging.basicConfig(level=logging.INFO)

# Initialize Firestore client
firestore_client = firestore.client()


def validate_and_parse_date(
    date_str: str, date_format: str = "%Y-%m-%dT%H:%M:%S"
) -> datetime:
    """Validate and parse the date string into a datetime object."""
    try:
        return datetime.strptime(date_str, date_format)
    except ValueError as e:
        raise ValueError(f"Invalid date format. Use {date_format}. Error: {str(e)}")


def normalize_date(date_obj: datetime) -> datetime:
    """Normalize the date to midnight."""
    return datetime(date_obj.year, date_obj.month, date_obj.day)


@https_fn.on_request()
def add_message(req: https_fn.Request) -> https_fn.Response:
    """Add a message to the Firestore database."""
    try:
        date_str = req.args.get("date")
        uid = req.args.get("uid")
        query = req.args.get("query")

        if not query:
            return https_fn.Response("No query parameter provided", status=400)
        if not date_str:
            return https_fn.Response("No date parameter provided", status=400)
        if not uid:
            return https_fn.Response("No uid parameter provided", status=400)

        date_obj = validate_and_parse_date(date_str)
        normalized_date = normalize_date(date_obj)

        message_entry = {
            "role": "user",
            "content": query,
            "timestamp": date_obj,
        }

        docs = (
            firestore_client.collection("messages")
            .where("uid", "==", uid)
            .where("date", "==", normalized_date)
            .stream()
        )

        doc = next(docs, None)

        if doc is None:
            firestore_client.collection("messages").add(
                {
                    "uid": uid,
                    "date": normalized_date,
                    "messages": [message_entry],
                }
            )
        else:
            doc.reference.update({"messages": firestore.ArrayUnion([message_entry])})

        return https_fn.Response("Message added successfully", status=200)

    except Exception as e:
        logging.error(f"Error in add_message: {str(e)}")
        return https_fn.Response(f"Internal server error: {str(e)}", status=500)


@https_fn.on_request()
def get_user_messages_by_date(req: https_fn.Request) -> https_fn.Response:
    """Retrieve user messages by date."""
    try:
        date_str = req.args.get("date")
        uid = req.args.get("uid")

        if not date_str:
            return https_fn.Response("No date parameter provided", status=400)
        if not uid:
            return https_fn.Response("No uid parameter provided", status=400)

        date_obj = validate_and_parse_date(date_str, "%Y-%m-%d")
        normalized_date = normalize_date(date_obj)

        docs = (
            firestore_client.collection("messages")
            .where("uid", "==", uid)
            .where("date", "==", normalized_date)
            .stream()
        )

        doc = next(docs, None)

        if doc is None:
            return https_fn.Response(
                "No messages found for the provided uid and date", status=404
            )

        messages = doc.to_dict().get("messages", [])

        for message in messages:
            message["timestamp"] = message["timestamp"].strftime("%Y-%m-%dT%H:%M:%S")

        return https_fn.Response(
            response=json.dumps({"messages": messages}),
            status=200,
            mimetype="application/json",
        )

    except ValueError as ve:
        logging.warning(f"Validation error in get_user_messages_by_date: {str(ve)}")
        return https_fn.Response(str(ve), status=400)

    except Exception as e:
        logging.error(f"Error in get_user_messages_by_date: {str(e)}")
        return https_fn.Response(f"Internal server error: {str(e)}", status=500)
