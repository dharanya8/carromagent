from pydantic import BaseModel
from datetime import date
class UserRegistration(BaseModel):
    name: str
    mobilenumber: str
    dateofbirth: date
    sportregistered: str