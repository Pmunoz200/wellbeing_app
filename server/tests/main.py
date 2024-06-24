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


def get_detail_response_request(server_url, date_str, uid, index, container):
    url = f"{server_url}/get_detailed_response"
    params = {
        "date": date_str,
        "uid": uid,
        "index": index,
        "container": container,
    }
    response = requests.get(url, params=params)
    # print content of response
    return response.json()


if __name__ == "__main__":
    server_url = "http://127.0.0.1:5001/wellbeing-app-d5a53/us-central1"

    date_str = "2021-06-01T14:00:00"
    uid = "manuel"

    # get user messages by date
    """ messages_request = get_user_messages_by_date_request(server_url, date_str, uid)
    for message in messages_request["conversation"]:
        content = json.loads(message["content"])
        print(json.dumps(content, indent=4)) """

    # get response
    """ query = "I ate three eggs for breakfast."
    response_request = get_response_request(server_url, date_str, uid, query)
    print(json.dumps(response_request, indent=4)) """

    # get detailed response
    """ detailed_response_request = get_detail_response_request(
        server_url, date_str, uid, 2, "food_summary"
    )
    print(detailed_response_request) """
