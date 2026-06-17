from agent.api_client import register_user, get_profile

def register_tool(user_data):
    return register_user(user_data)

def profile_tool(mobilenumber):
    return get_profile(mobilenumber)