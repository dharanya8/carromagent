import ollama
from datetime import datetime
from tools import register_tool, profile_tool

MODEL = "gemma3:1b"

SYSTEM_PROMPT = """
You are a Carrom Sports Registration Assistant.

Classify the user's intent.

Possible outputs:

REGISTER
GET_PROFILE
EXIT
UNKNOWN

Return only one word.
"""

def detect_intent(message):

    response = ollama.chat(
        model=MODEL,
        messages=[
            {
                "role": "system",
                "content": SYSTEM_PROMPT
            },
            {
                "role": "user",
                "content": message
            }
        ]
    )

    return response["message"]["content"].strip().upper()


def handle_message(message):

    msg = message.lower()

    # Greeting
    if any(word in msg for word in [
        "hi",
        "hii",
        "hello",
        "hey",
        "good morning",
        "good afternoon",
        "good evening"
    ]):
        intent = "GREETING"

    # Profile lookup
    elif any(word in msg for word in [
        "profile",
        "check registration",
        "my registration",
        "registered",
        "which sport",
        "show my registration",
        "show my profile",
        "registration details"
    ]):
        intent = "GET_PROFILE"

    # Registration
    elif any(word in msg for word in [
        "register",
        "sign up",
        "join",
        "enroll",
        "participate"
    ]):
        intent = "REGISTER"

    else:
        intent = detect_intent(message)

    # GREETING
    if intent == "GREETING":

        return (
            "Hello! 👋\n"
            "How can I help you today?\n\n"
            "1. Register for a tournament\n"
            "2. Check your registration details"
        )

    # REGISTER
    elif intent == "REGISTER":

        name = input("Name: ")

        while True:

            dateofbirth = input(
                "Date of Birth (YYYY-MM-DD): "
            )

            try:
                datetime.strptime(
                    dateofbirth,
                    "%Y-%m-%d"
                )
                break

            except ValueError:
                print(
                    "Invalid DOB format. Use YYYY-MM-DD"
                )

        mobilenumber = input(
            "Mobile Number: "
        )

        print("""
Available Categories

1. Singles
2. Doubles
3. Knockout
4. Robin
""")

        choice = input(
            "Select category number: "
        )

        mapping = {
            "1": "Singles",
            "2": "Doubles",
            "3": "Knockout",
            "4": "Robin"
        }

        sportregistered = mapping.get(choice)

        if sportregistered is None:
            return (
                "Invalid category selected."
            )

        data = {
            "name": name,
            "dateofbirth": dateofbirth,
            "mobilenumber": mobilenumber,
            "sportregistered": sportregistered
        }

        result = register_tool(data)

        if "detail" in result:

            return (
                f"Registration Failed: "
                f"{result['detail'][0]['msg']}"
            )

        return (
            "Registration Successful ✅"
        )

    # PROFILE
    elif intent == "GET_PROFILE":

        mobilenumber = input(
            "Enter Mobile Number: "
        )

        result = profile_tool(
            mobilenumber
        )

        if "message" in result:
            return result["message"]

        return f"""
Registration Details

Name : {result['name']}
Date of Birth : {result['dateofbirth']}
Mobile Number : {result['mobilenumber']}
Sport Registered : {result['sportregistered']}
"""

    else:

        return (
            "I can help you with:\n"
            "1. Tournament Registration\n"
            "2. Checking Registration Details"
        )


if __name__ == "__main__":

    while True:

        message = input("\nUser: ")

        if message.lower() in [
            "exit",
            "quit",
            "bye",
            "stop",
            "terminate"
        ]:

            print(
                "\nAgent: Thank you for using "
                "Carrom Registration Assistant 👋"
            )

            break

        response = handle_message(
            message
        )

        print("\nAgent:")
        print(response)