from __future__ import annotations

from uuid import UUID

from pydantic import BaseModel

from src.models.groups import Area
from src.models.users import Gender, User


class UserSchema(BaseModel):
    """User schema for the API"""

    user_id: str
    name: str
    email: str
    phone: str
    gender: Gender
    description: str
    is_trainer: bool
    is_coach: bool

    @staticmethod
    def from_model(user: User) -> UserSchema:
        return UserSchema(
            user_id=str(user.user_id),
            name=user.name,
            email=user.email,
            phone=user.phone,
            gender=user.gender,
            description=user.description,
            is_trainer=user.is_trainer,
            is_coach=user.is_coach,
        )


class AreaSchema(BaseModel):
    area_id: str
    name: str

    @staticmethod
    def from_model(area: Area) -> AreaSchema:
        return AreaSchema(
            area_id=str(area.area_id),
            name=area.name,
        )


class LoginResponseSchema(BaseModel):
    auth_token: UUID
    user: UserSchema
    areas: list[AreaSchema]
