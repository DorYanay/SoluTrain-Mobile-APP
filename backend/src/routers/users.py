from __future__ import annotations

from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel

from src.models import db_dependency
from src.models.users import Gender, User, create_user, get_user_by_email, get_user_by_id

router = APIRouter()


class UserSchema(BaseModel):
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


@router.post("/signup")
async def route_signup(
    name: str,
    email: str,
    password: str,
    phone: str,
    gender: Gender,
    is_trainer: bool,
    is_coach: bool,
    db: psycopg.Connection = Depends(db_dependency),
) -> UserSchema:
    if get_user_by_email(db, email) is not None:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="User already exists with this email")

    # TODO: Hash password
    password_hash = "#" + password

    user = create_user(db, name, email, password_hash, phone, gender, is_trainer, is_coach)

    return UserSchema.from_model(user)


@router.get("/{user_id}")
async def route_get_user(user_id: UUID, db: psycopg.Connection = Depends(db_dependency)) -> UserSchema:
    user = get_user_by_id(db, user_id)

    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    return UserSchema.from_model(user)
