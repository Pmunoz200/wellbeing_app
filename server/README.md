# Firebase Functions API

This API provides endpoints for retrieving messages by user and date, and for adding messages to the Firestore database and generating responses using the Gemini model.

## Table of Contents
- [Firebase Functions API](#firebase-functions-api)
  - [Table of Contents](#table-of-contents)
  - [Endpoints](#endpoints)
    - [GET /get\_user\_messages\_by\_date](#get-get_user_messages_by_date)
      - [Request](#request)
      - [Response](#response)
    - [GET /get\_response](#get-get_response)
      - [Request](#request-1)
      - [Response](#response-1)
  - [Error Handling](#error-handling)
  - [Additional Notes](#additional-notes)

## Endpoints

### GET /get_user_messages_by_date

Retrieve user messages by date.

#### Request

- **Method:** GET
- **URL:** `/get_user_messages_by_date`
- **Query Parameters:**
  - `uid` (string, required): The user ID.
  - `date` (string, required): The date in `%Y-%m-%dT%H:%M:%S` format.

#### Response

- **Status:** 200 OK
- **Body:** JSON object containing the conversation.
  ```json
  {
    "conversation": [
      {
        "role": "model",
        "content": "Message content"
      },
      ...
    ]
  }
  ```

### GET /get_response

Add a message to the Firestore database and get a response from the Gemini model.

#### Request

- **Method:** GET
- **URL:** `/get_response`
- **Query Parameters:**
  - `uid` (string, required): The user ID.
  - `query` (string, required): The user query.
  - `date` (string, required): The date in `%Y-%m-%dT%H:%M:%S` format.

#### Response

- **Status:** 200 OK
- **Body:** JSON object containing the conversation.
  ```json
  {
    "conversation": [
      {
        "role": "model",
        "content": "Message content"
      },
      ...
    ]
  }
  ```

## Error Handling

Errors are returned with appropriate HTTP status codes and a descriptive message.

- **400 Bad Request:** Returned when the required query parameters are missing or invalid.
- **500 Internal Server Error:** Returned for any unexpected errors on the server.

## Additional Notes
[Gemini API Docs](https://ai.google.dev/gemini-api/docs/get-started/tutorial?lang=python&authuser=0)