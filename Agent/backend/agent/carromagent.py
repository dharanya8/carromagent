import re
from datetime import datetime

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

    if not number.isdigit():
        return False

    if len(number) == 10:
        return True

    if len(number) == 12 and number.startswith("91"):
        return True

    return False


def is_valid_dob(dob):

    try:
        datetime.strptime(
            dob,
            "%Y-%m-%d"
        )
        return True

    except ValueError:
        return False


# -----------------------------
# INTENT DETECTION
# -----------------------------

def detect_intent(message):

    try:

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

        return (
            response["message"]["content"]
            .strip()
            .upper()
        )

    except Exception:
        return "UNKNOWN"


# -----------------------------
# MAIN HANDLER
# -----------------------------

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
            "2. Check Registration Details"
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
                "Sakthi Kumar"
            )

        session["data"]["name"] = message
        session["state"] = "WAITING_DOB"

        return "Please enter Date of Birth (YYYY-MM-DD):"

    if session["state"] == "WAITING_DOB":

        if not is_valid_dob(message):

            return (
                "❌ Invalid Date of Birth.\n\n"
                "Please enter DOB in YYYY-MM-DD format.\n\n"
                "Example:\n"
                "2003-08-15"
            )

        session["data"]["dateofbirth"] = message
        session["state"] = "WAITING_MOBILE"

        return (
            "Please enter Mobile Number.\n"
            "Accepted formats:\n"
            "9965484873\n"
            "919965484873"
        )

    if session["state"] == "WAITING_MOBILE":

        if not is_valid_mobile(message):

            return (
                "❌ Invalid Mobile Number.\n\n"
                "Enter:\n"
                "- 10 digit mobile number\n"
                "OR\n"
                "- 12 digits with country code (91)"
            )

        session["data"]["mobilenumber"] = message
        session["state"] = "WAITING_CATEGORY"

        return (
            "Select Category:\n\n"
            "1. Singles\n"
            "2. Doubles\n"
            "3. Knockout\n"
            "4. Robin"
        )

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