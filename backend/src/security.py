import hashlib
from uuid import UUID, uuid4

import psycopg
from fastapi import Depends, HTTPException, status

from src.models import db_dependency
from src.models.users import User, get_user_by_id


# hash handling
def create_hash(text: str) -> str:
    text_as_bytes = text.encode("utf-8")

    # Hash the password using SHA-256
    hashed_text = hashlib.sha256(text_as_bytes).hexdigest()

    return hashed_text


def verify_hash(text: str, hashed_text: str) -> bool:
    input_password_hashed = create_hash(text)

    return input_password_hashed == hashed_text


# authentication
auth_logged_users: dict[UUID, UUID] = {}


def login_user(user: User) -> UUID:
    token = uuid4()

    while token in auth_logged_users:
        token = uuid4()

    auth_logged_users[token] = user.user_id

    return token


def logout_user(auth_token: UUID, user: User) -> None:
    saved_user_id = auth_logged_users.get(auth_token)
    if saved_user_id is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication credentials")

    if not saved_user_id == user.user_id:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication credentials")

    auth_logged_users.pop(auth_token)


def get_current_user(auth_token: UUID, db: psycopg.Connection = Depends(db_dependency)) -> User:
    """FastAPI dependency to get the current logged user (from the auth token)"""

    user_id = auth_logged_users.get(auth_token)
    if user_id is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication credentials")

    user = get_user_by_id(db, user_id)

    if user is None:
        auth_logged_users.pop(auth_token)
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication credentials")

    return user
