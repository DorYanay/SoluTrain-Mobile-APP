from __future__ import annotations

from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel

from src.models import db_dependency
from src.models.users import Gender, User, get_user_by_id
from src.security import get_current_user

router = APIRouter()


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


# Examples of endpoints.
# They are not necessary, but they are useful for testing the API and learning the code
@router.post("/get")
def route_get_user(user_id: UUID, db: psycopg.Connection = Depends(db_dependency)) -> UserSchema:
    """Example of endpoint. Find user by ID"""

    user = get_user_by_id(db, user_id)

    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    return UserSchema.from_model(user)


@router.post("/me")
def route_me(current_user: User = Depends(get_current_user)) -> UserSchema:
    """Example of endpoint. Return the logged user"""

    return UserSchema.from_model(current_user)


@router.post("/get-with-auth")
def route_get_with_auth(
    user_ids: list[UUID], db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> dict[UUID, UserSchema | None]:
    """Example of endpoint. Return list of users only if the user is a coach"""

    if not current_user.is_coach:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="You are not a coach")

    result: dict[UUID, UserSchema | None] = {}

    for user_id in user_ids:
        user = get_user_by_id(db, user_id)
        if user is None:
            result[user_id] = None
        else:
            result[user_id] = UserSchema.from_model(user)

    return result
