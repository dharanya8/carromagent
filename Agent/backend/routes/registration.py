from fastapi import APIRouter
from schema.users import UserRegistration
from services.registration_service import register_user, get_user_by_mobile
router=APIRouter()

@router.post("/register")
def register(data:UserRegistration):
    register_user(
        data.name,
        data.mobilenumber,
        data.dateofbirth,
        data.sportregistered
    )
    return {"message":"User registered successfully"}

@router.get("/profile/{mobilenumber}")
def get_profile(mobilenumber: str):

    user = get_user_by_mobile(mobilenumber)

    if not user:
        return {"message": "User not found"}

    return {
        "userid": user[0],
        "name": user[1],
        "dateofbirth": str(user[2]),
        "mobilenumber": user[3],
        "sportregistered": user[4]
    }