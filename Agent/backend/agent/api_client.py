import requests

BASE_URL = "http://localhost:8000"

def register_user(user_data):
    response = requests.post(
        f"{BASE_URL}/register",
        json=user_data
    )
    return response.json()

def get_profile(mobilenumber):
    response = requests.get(
        f"{BASE_URL}/profile/{mobilenumber}"
    )
    return response.json()