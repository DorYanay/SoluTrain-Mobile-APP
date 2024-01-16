import hashlib
from uuid import UUID, uuid4

from fastapi import HTTPException, status

from src.models.users import User


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
auth_logged_users: dict[UUID, User] = {}


def login_user(user: User) -> UUID:
    token = uuid4()

    while token in auth_logged_users:
        token = uuid4()

    auth_logged_users[token] = user

    return token


def logout_user(auth_token: UUID, user: User) -> None:
    saved_user = auth_logged_users.get(auth_token)
    if saved_user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication credentials")

    if not saved_user.user_id == user.user_id:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication credentials")

    auth_logged_users.pop(auth_token)


def get_current_user(auth_token: UUID) -> User:
    """FastAPI dependency to get the current logged user (from the auth token)"""

    user = auth_logged_users.get(auth_token)
    if user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication credentials")

    return user
