# Firebase Functions API

This API provides endpoints for retrieving messages by user and date, and for adding messages to the Firestore database and generating responses using the Gemini model.

## Table of Contents
- [Firebase Functions API](#firebase-functions-api)
  - [Table of Contents](#table-of-contents)
  - [Endpoints](#endpoints)
    - [GET /get\_user\_messages\_by\_date](#get-get_user_messages_by_date)
      - [Request](#request)
      - [Response](#response)
      - [Example](#example)
    - [GET /get\_response](#get-get_response)
      - [Request](#request-1)
      - [Response](#response-1)
      - [Example](#example-1)
    - [GET /get\_detailed\_response](#get-get_detailed_response)
      - [Request](#request-2)
      - [Response](#response-2)
      - [Example](#example-2)
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
        "content": {
          "summary": "Summary message",
          "suggestion": "Suggestion message",
          "food": {
            "summary": "Food summary",
            "calories_consumed": 0,
            "carbs": 0,
            "protein": 0,
            "fat": 0,
            "suggestion": "Food suggestion"
          },
          "exercise": {
            "summary": "Exercise summary",
            "calories_burned": 0,
            "type": null,
            "muscle_groups": [],
            "suggestion": "Exercise suggestion"
          }
        }
      },
      ...
    ]
  }
  ```

#### Example

**Request:**
```sh
curl -X GET "https://your-api-url/get_user_messages_by_date?uid=user123&date=2024-06-22T12:00:00"
```

**Response:**
```json
{
  "conversation": [
    {
      "role": "model",
      "content": {
        "summary": "You haven't logged any food or exercise yet today.  Let's get started with a healthy breakfast to fuel your day.",
        "suggestion": "Start your day with a balanced breakfast, such as oatmeal with berries and nuts, or a smoothie with protein powder and fruit. This will provide sustained energy and keep you feeling full until your next meal.",
        "food": {
          "summary": "You haven't eaten anything yet today.  Start with a balanced breakfast to fuel your day.",
          "calories_consumed": 0,
          "carbs": 0,
          "protein": 0,
          "fat": 0,
          "suggestion": "Start your day with a balanced breakfast, such as oatmeal with berries and nuts, or a smoothie with protein powder and fruit. This will provide sustained energy and keep you feeling full until your next meal."
        },
        "exercise": {
          "summary": "You haven't logged any exercise yet today.  Consider starting your day with a light workout.",
          "calories_burned": 0,
          "type": null,
          "muscle_groups": [],
          "suggestion": "Consider starting your day with a light workout, such as a 30-minute walk or a quick yoga session. This will help to boost your energy levels and improve your mood."
        }
      }
    }
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
        "content": {
          "summary": "Summary message",
          "suggestion": "Suggestion message",
          "food": {
            "summary": "Food summary",
            "calories_consumed": 0,
            "carbs": 0,
            "protein": 0,
            "fat": 0,
            "suggestion": "Food suggestion"
          },
          "exercise": {
            "summary": "Exercise summary",
            "calories_burned": 0,
            "type": null,
            "muscle_groups": [],
            "suggestion": "Exercise suggestion"
          }
        }
      },
      ...
    ]
  }
  ```

#### Example

**Request:**
```sh
curl -X GET "https://your-api-url/get_response?uid=user123&query=Tell%20me%20a%20joke&date=2024-06-22T12:05:00"
```

**Response:**
```json
{
  "conversation": [
    {
      "role": "model",
      "content": {
        "summary": "You haven't logged any food or exercise yet today. Let's get started!",
        "suggestion": "It's early in the day. How about starting with a nutritious breakfast to fuel your morning?",
        "food": {
          "summary": "You haven't logged any food yet today.  Let's start with a healthy breakfast!",
          "calories_consumed": 0,
          "carbs": 0,
          "protein": 0,
          "fat": 0,
          "suggestion": "A balanced breakfast with protein, fiber, and healthy fats will keep you energized throughout the morning. Consider oatmeal with berries and nuts, or eggs with whole-wheat toast."
        },
        "exercise": {
          "summary": "You haven't logged any exercise yet today.  Let's get moving!",
          "calories_burned": 0,
          "type": null,
          "muscle_groups": [],
          "suggestion": "Even a short walk or some light stretching can help you feel more energized and focused.  Choose an activity you enjoy and get your body moving!"
        }
      }
    },
    {
      "role": "model",
      "content": {
        "summary": "You've had a great start to the day with a protein-packed breakfast!  Let's keep the momentum going with a balanced lunch and some exercise.",
        "suggestion": "It's early in the day.  Consider a light, healthy snack before your next meal to keep you feeling satisfied.",
        "food": {
          "summary": "You've started your day with a good amount of protein from your eggs.  Keep up the good work!",
          "calories_consumed": 210,
          "carbs": 0,
          "protein": 18,
          "fat": 15,
          "suggestion": "Try adding some fiber-rich fruits or vegetables to your next meal to keep your energy levels stable throughout the day.  Consider a salad with grilled chicken or a whole-wheat wrap with hummus and veggies."
        },
        "exercise": {
          "summary": "You haven't logged any exercise yet today.  Let's get moving!",
          "calories_burned": 0,
          "type": null,
          "muscle_groups": [],
          "suggestion": "Even a short walk or some light stretching can help you feel more energized and focused.  Choose an activity you enjoy and get your body moving!"
        }
      }
    }
  ]
}
```

### GET /get_detailed_response

Add a message to the Firestore database and get a detailed response.

#### Request

- **Method:** GET
- **URL:** `/get_detailed_response`
- **Query Parameters:**
  - `uid` (string, required): The user ID.
  - `index` (string, required): The index of the message in the conversation.
  - `container` (string, required): The container to retrieve details for (summary, suggestion, food_summary, food_suggestion, exercise_summary, exercise_suggestion).
  - `date` (string, required): The date in `%Y-%m-%dT%H:%M:%S` format.

#### Response

- **Status:** 200 OK
- **Body:** JSON object containing the detailed response.
  ```json
  {
    "content": "Detailed content message"
  }
  ```

#### Example

**Request:**
```sh
curl -X GET "https://your-api-url/get_detailed_response?uid=user123&index=0&container=food_summary&date=2024-06-22T12:05:00"
```

**Response:**
```json
{
  "content": "You've had three eggs for breakfast, which is a good source of protein. Each egg provides approximately 70 calories, 6 grams of protein, and 5 grams of fat. This means your breakfast has contributed about 210 calories, 18 grams of protein, and 15 grams of fat to your daily intake. While eggs are a nutritious choice, it's important to remember that they are relatively high in cholesterol. It's a good idea to balance your intake with other foods that are lower in cholesterol and saturated fat. You haven't tracked any other food yet today, so it's important to keep track of your food intake throughout the day to ensure you're getting enough nutrients and calories to meet your needs."
}
```

## Error Handling

Errors are returned with appropriate HTTP status codes and a descriptive message.

- **400 Bad Request:** Returned when the required query parameters are missing or invalid.
- **500 Internal Server Error:** Returned for any unexpected errors on the server.

## Additional Notes
[Gemini API Docs](https://ai.google.dev/gemini-api/docs/get-started/tutorial?lang=python&authuser=0)