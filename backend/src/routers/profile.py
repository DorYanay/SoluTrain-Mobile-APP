from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, File, HTTPException
from starlette import status

from src.models import db_dependency
from src.models.users import User, get_user_by_email, get_user_by_id, update_user, update_user_password, user_upload_certificate
from src.schemas import UserSchema
from src.security import create_hash, get_current_user, update_auth_logged_user_data
from src.validators import validate_certificate_name, validate_email

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/get")
def route_get(current_user: User = Depends(get_current_user)) -> UserSchema:
    return UserSchema.from_model(current_user)


@router.post("/upload-first-certificate")
def route_upload_first_certificate(
    file_name: str, file: bytes = File(), db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    if current_user.is_coach:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Your already have a first certificate")

    if file_name == "":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="File name cannot be empty")

    if not validate_certificate_name(file_name):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Only .pdf, .jpg, .jpeg, .png files are allowed")

    user_upload_certificate(db, current_user.user_id, file_name, file)


@router.post("/update-details")
def route_update_details(
    auth_token: UUID,
    new_name: str | None = None,
    new_email: str | None = None,
    new_phone: str | None = None,
    new_description: str | None = None,
    db: psycopg.Connection = Depends(db_dependency),
    current_user: User = Depends(get_current_user),
) -> UserSchema:
    updated_name = current_user.name
    updated_email = current_user.email
    updated_phone = current_user.phone
    updated_description = current_user.description

    # validation
    if new_email is not None:
        if not validate_email(new_email):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid email")

        if get_user_by_email(db, new_email) is not None:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="User already exists with this email")

        updated_email = new_email

    if new_name is not None:
        updated_name = new_name

    if new_phone is not None:
        updated_phone = new_phone

    if new_description is not None:
        updated_description = new_description

    update_user(db, current_user.user_id, updated_name, updated_email, updated_phone, updated_description)

    user = get_user_by_id(db, current_user.user_id)

    if user is None:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Internal server error")

    update_auth_logged_user_data(auth_token, user)

    return UserSchema.from_model(user)


@router.post("/update-password")
def route_update_password(
    new_password: str, auth_token: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> UserSchema:
    password_hash = create_hash(new_password)

    update_user_password(db, current_user.user_id, password_hash)

    user = get_user_by_id(db, current_user.user_id)

    if user is None:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Internal server error")

    update_auth_logged_user_data(auth_token, user)

    return UserSchema.from_model(user)
