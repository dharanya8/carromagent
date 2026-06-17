from email.mime import message
import re
from datetime import datetime
from unittest import result

from requests import session


from agent.tools import register_tool, profile_tool

# -----------------------------
# SESSION STORAGE
# -----------------------------
user_sessions = {}

# -----------------------------
# VALIDATIONS
# -----------------------------

def is_valid_name(name):
    return bool(
        re.fullmatch(
            r"[A-Za-z ]{2,50}",
            name.strip()
        )
    )


def is_valid_mobile(number):

    number = number.strip()
    return bool(
        re.fullmatch(
            r"\d{10}",
            number
        )
    )
    
    def is_valid_dob(dob):
        dob = dob.strip()
        formats = [
            "%Y-%m-%d",
            "%d-%m-%Y",
            "%d/%m/%Y",
            "%Y/%m/%d"
            ]

        for fmt in formats:
            try:
                datetime.strptime(dob, fmt)
                return True
            except ValueError:
                continue

    return False

# # -----------------------------
# # MAIN HANDLER
# # -----------------------------

def handle_message(message):

    message = message.strip()
    session = user_sessions.setdefault(
    "default",
    {
        "state": None,
        "data": {}
    }
)

    msg = message.lower()
    if msg in ["menu", "restart", "reset"]:

        session["state"] = None
        session["data"] = {}

        return (
            "Welcome to Toto Carrom Tournament Assistant 👋\n\n"
            "1. Register for a Tournament\n"
            "2. Check Registration Details\n"
        )

    # ---------------------------------
    # EXIT WORDS
    # ---------------------------------

    exit_words = [
        "bye",
        "goodbye",
        "thanks",
        "thank you",
        "thankyou",
        "done",
        "exit",
        "quit",
        "okay"
    ]

    if msg in exit_words:

        session["state"] = None
        session["data"] = {}

        return (
            "Thank you for using Toto Carrom Assistant 😊\n"
            "Have a great day!"
        )

    # ---------------------------------
    # REGISTER FLOW
    # ---------------------------------

    if session["state"] == "WAITING_NAME":

        if not is_valid_name(message):

            return (
                "❌ Invalid name.\n\n"
                "Name should contain only alphabets and spaces.\n\n"
                "Example:\n"
                "Sakthi\n"
                "John Doe"
            )

        session["data"]["name"] = message
        session["state"] = "WAITING_DOB"

        return "Please enter Date of Birth:"
    
    if session["state"] == "WAITING_DOB":
        parsed_date = None
        formats = [
            "%Y-%m-%d",
            "%d-%m-%Y",
            "%d/%m/%Y",
            "%Y/%m/%d"
        ]
        for fmt in formats:
            try:
                parsed_date = datetime.strptime(
                    message.strip(),
                    fmt
                )
                break
            except ValueError:
                pass

        if parsed_date is None:
            return (
                "❌ Invalid Date of Birth.\n\n"
                "Examples:\n"
                "2003-08-15\n"
                "15-08-2003\n"
                "3-8-2003"
            )

        session["data"]["dateofbirth"] = parsed_date.strftime(
            "%Y-%m-%d"
        )

        session["state"] = "WAITING_MOBILE"

        return "Please enter Mobile Number."

    if session["state"] == "WAITING_MOBILE":

        if not is_valid_mobile(message):
            return (
                "❌ Invalid Mobile Number.\n\n"
                "Please enter exactly 10 digits.\n\n"
                "Example:\n"
                "9876543210"
            )

        session["data"]["mobilenumber"] = message

        result = profile_tool(message)

        if "message" not in result:
            session["data"]["existing_registration"] = result
            session["state"] = "WAITING_EXISTING_REGISTRATION"

            return (
                f"You have already registered for "
                f"{result['sportregistered']}.\n\n"
                "Do you want to make another registration?\n\n"
                "Type Yes or No"
            )

        session["state"] = "WAITING_CATEGORY"

        return (
            "Select Category:\n\n"
            "1. Singles\n"
            "2. Doubles\n"
            "3. Knockout\n"
            "4. Robin"
        )

    if session["state"] == "WAITING_EXISTING_REGISTRATION":

        if msg == "yes":

            session["state"] = "WAITING_CATEGORY"

            return (
                "Select Category:\n\n"
                "1. Singles\n"
                "2. Doubles\n"
                "3. Knockout\n"
                "4. Robin"
            )

        elif msg == "no":

            session["state"] = None
            session["data"] = {}

            return "Registration cancelled."

        else:
            return "Please type Yes or No."
    

    if session["state"] == "WAITING_CATEGORY":

        category_map = {
            "1": "Singles",
            "2": "Doubles",
            "3": "Knockout",
            "4": "Robin"
        }

        category = category_map.get(message)

        if not category:

            return (
                "❌ Invalid option.\n\n"
                "Please select:\n"
                "1. Singles\n"
                "2. Doubles\n"
                "3. Knockout\n"
                "4. Robin"
            )

        session["data"]["sportregistered"] = category

        result = register_tool(
            session["data"]
        )

        session["state"] = None
        session["data"] = {}

        if "detail" in result:

            return (
                f"Registration Failed ❌\n"
                f"{result['detail'][0]['msg']}"
            )

        return (
            "Registration Successful ✅\n\n"
            "You're all set!\n"
            "We look forward to seeing you at the event. 🎉"
        )

    # ---------------------------------
    # PROFILE FLOW
    # ---------------------------------

    if session["state"] == "WAITING_PROFILE_MOBILE":

        if not is_valid_mobile(message):

            return (
                "❌ Invalid Mobile Number.\n\n"
                "Please enter a valid registered mobile number."
            )

        result = profile_tool(message)

        session["state"] = None

        if "message" in result:
            return result["message"]

        return (
            "📋 Registration Details\n\n"
            f"Name: {result['name']}\n"
            f"Date of Birth: {result['dateofbirth']}\n"
            f"Mobile Number: {result['mobilenumber']}\n"
            f"Sport Registered: {result['sportregistered']}"
        )

    # ---------------------------------
    # GREETINGS
    # ---------------------------------

    greetings = [
        "hi",
        "hii",
        "hello",
        "hey",
        "good morning",
        "good afternoon",
        "good evening"
    ]

    if msg in greetings:

        return (
            "Hello! 👋\n\n"
            "Welcome to Toto Carrom Tournament Assistant.\n\n"
            "How can I help you today?\n\n"
            "1. Register for a Tournament\n"
            "2. Check Registration Details"
        )

    # ---------------------------------
    # MENU OPTIONS
    # ---------------------------------

    if message == "1":

        session["state"] = "WAITING_NAME"
        session["data"] = {}

        return "Please enter your full name:"

    if message == "2":

        session["state"] = "WAITING_PROFILE_MOBILE"

        return "Please enter your registered mobile number:"

    # ---------------------------------
    # KEYWORD DETECTION
    # ---------------------------------

    register_keywords = [
        "register",
        "join",
        "participate",
        "sign up",
        "enroll"
    ]

    profile_keywords = [
        "profile",
        "registration",
        "check registration",
        "registration details",
        "my registration"
    ]

    if any(word in msg for word in register_keywords):

        session["state"] = "WAITING_NAME"
        session["data"] = {}

        return "Please enter your full name:"

    if any(word in msg for word in profile_keywords):

        session["state"] = "WAITING_PROFILE_MOBILE"

        return "Please enter your registered mobile number:"

    # ---------------------------------
    # UNKNOWN INPUT
    # ---------------------------------

    return (
        "❓ I couldn't understand that.\n\n"
        "Please choose one of the following:\n\n"
        "1. Register for a Tournament\n"
        "2. Check Registration Details\n\n"
        "Or type:\n"
        "- register\n"
        "- registration details"
    )