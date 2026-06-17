from fastapi import APIRouter
##from flask import app
from flask import app
from pydantic import BaseModel
from agent.carromagent import handle_message

router = APIRouter()

class ChatRequest(BaseModel):
    message: str

@router.post("/chat")
def chat(request: ChatRequest):

    reply = handle_message(
        request.message,

    )

    return {"reply": reply}