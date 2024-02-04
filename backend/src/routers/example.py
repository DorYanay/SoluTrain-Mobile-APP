from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status

from src.models import db_dependency
from src.models.users import User, get_user_by_id
from src.schemas import UserSchema
from src.security import get_current_user

router = APIRouter()


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
