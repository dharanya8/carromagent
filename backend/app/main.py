from fastapi import FastAPI
from routes.registration import router

app = FastAPI()
app.include_router(router)

@app.get("/")
def home():
    return {"message": "Welcome to the WhatsApp Registration API"}