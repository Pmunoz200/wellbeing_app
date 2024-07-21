import google.generativeai as genai
from datetime import datetime
import logging
import os

from utils.date_utils import time_str
from utils.prompt_utils import (
    system_instructions,
    system_instructions_without_format,
)


def get_gemini_response(
    key: str,
    db_conversation: list,
    query: str,
    user_information: dict,
    date: datetime,
    output_format=True,
) -> list:
    """Get a response from the Gemini model and update the conversation."""
    try:
        # Add user query to the conversation
        db_conversation.append(db_message("user", query, date))
        query_messages = [message["gemini_message"] for message in db_conversation]
        response = call_gemini(key, query_messages, user_information, output_format)
        db_conversation.append(db_message("model", response, date))
        return db_conversation
    except Exception as e:
        logging.error(f"Error in get_gemini_response: {str(e)}")
        raise


def gemini_message(role: str, content: str, date: datetime) -> dict:
    """Create a formatted message for the Gemini model."""
    if role == "user":
        content = f"{time_str(date)}: {content}"
    return {
        "role": role,
        "parts": [content],
    }


def call_gemini(
    key: str,
    messages: list[dict],
    user_information: dict,
    temperature: float = 0.7,
    max_output_tokens: int = 500,
    output_format: bool = True,
):
    genai.configure(api_key=key)
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


def db_message(role: str, content: str, date: datetime) -> dict:
    """Format message for Firestore."""
    return {
        "gemini_message": gemini_message(role, content, date),
        "timestamp": date,
    }


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
