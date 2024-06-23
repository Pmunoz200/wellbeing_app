import requests
import json
import random


def get_response_request(server_url, date_str, uid, query):
    url = f"{server_url}/get_response"
    params = {"date": date_str, "uid": uid, "query": query}
    response = requests.get(url, params=params)
    return response.json()


def get_user_messages_by_date_request(server_url, date_str, uid):
    url = f"{server_url}/get_user_messages_by_date"
    params = {"date": date_str, "uid": uid}
    response = requests.get(url, params=params)
    return response.json()


if __name__ == "__main__":
    server_url = "http://127.0.0.1:5001/wellbeing-app-d5a53/us-central1"
    date_str = "2021-06-01T00:00:00"
    uid = str(random.randint(0, 1000))
    messages_request = get_user_messages_by_date_request(server_url, date_str, uid)
    # print(json.dumps(messages_request, indent=4))
    query = "I ate three eggs for breakfast."
    response_request = get_response_request(server_url, date_str, uid, query)
    # print(json.dumps(response_request, indent=4))
    for message in response_request["conversation"]:
        content = json.loads(message["content"])
        print(json.dumps(content, indent=4))
