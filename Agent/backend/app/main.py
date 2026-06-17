from fastapi import FastAPI
from routes.registration import router
from routes.chats import router as chat_router
from services.registration_service import get_all_users
app = FastAPI()
app.include_router(router)
app.include_router(chat_router)

@app.get("/")
def home():

    users = get_all_users()

    return [
        {
            "userid": user[0],
            "name": user[1],
            "dateofbirth": str(user[2]),
            "mobilenumber": user[3],
            "sportregistered": user[4]
        }
        for user in users
    ]

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)