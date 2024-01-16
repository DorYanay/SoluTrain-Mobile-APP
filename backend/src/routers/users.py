from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel

from src.models import db_dependency
from src.models.users import Gender, create_user, get_user_by_email, get_user_by_id

router = APIRouter()


class UserSchema(BaseModel):
    user_id: str
    name: str
    email: str
    gender: Gender
    description: str


@router.get("/{user_id}")
async def route_get_user(user_id: UUID, db: psycopg.Connection = Depends(db_dependency)) -> UserSchema:
    user = get_user_by_id(db, user_id)

    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    return UserSchema(
        user_id=str(user.user_id),
        name=user.name,
        email=user.email,
        gender=user.gender,
        description=user.description,
    )


@router.post("/create")
async def route_create_user(name: str, email: str, gender: Gender, db: psycopg.Connection = Depends(db_dependency)) -> UserSchema:
    if get_user_by_email(db, email) is not None:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="User already exists with this email")

    user = create_user(db, name, email, gender)

    return UserSchema(
        user_id=str(user.user_id),
        name=user.name,
        email=user.email,
        gender=user.gender,
        description=user.description,
    )
