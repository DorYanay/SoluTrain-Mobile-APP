import os

import psycopg
from fastapi import APIRouter, Depends, HTTPException, Response, UploadFile, status
from fastapi.responses import FileResponse

from src.config import config
from src.models import db_dependency
from src.models.users import (
    Gender,
    User,
    delete_user_certificate,
    delete_user_profile_image,
    get_user_by_email,
    get_user_by_id,
    get_user_certificate,
    get_user_certificates,
    get_user_profile_image,
    update_user,
    update_user_password,
    user_upload_certificate,
    user_upload_profile_image,
)
from src.schemas import CertificatesSchema, UserSchema
from src.security import create_hash, get_current_user
from src.validators import validate_certificate_name, validate_email, validate_profile_picture_name

router = APIRouter(dependencies=[Depends(get_current_user)])


def _get_api_media_type(name: str) -> str:
    if name.endswith(".pdf"):
        return "application/pdf"
    elif name.endswith(".jpg") or name.endswith(".jpeg"):
        return "image/jpeg"
    elif name.endswith(".png"):
        return "image/png"

    return "application/octet-stream"


@router.post("/get")
def route_get(current_user: User = Depends(get_current_user)) -> UserSchema:
    return UserSchema.from_model(current_user)


@router.post("/get-certificates")
def route_get_certificates(
    db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> CertificatesSchema:
    certificates = get_user_certificates(db, current_user.user_id)

    return CertificatesSchema.from_model(certificates)


@router.get("/get-certificate")
def route_get_certificate(
    certificate_id: str, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> Response:
    certificate = get_user_certificate(db, current_user.user_id, certificate_id)

    if certificate is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Certificate not found")

    return Response(content=certificate.body, media_type=_get_api_media_type(certificate.name))


@router.post("/upload-first-certificate")
async def route_upload_first_certificate(
    file: UploadFile, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    if current_user.is_coach:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Your already have a first certificate")

    if file.filename is None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="File name is empty")

    if not validate_certificate_name(file.filename):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Only .pdf, .jpg, .jpeg, .png files are allowed")

    file_body = await file.read()

    user_upload_certificate(db, current_user.user_id, file.filename, file_body)


@router.post("/upload-certificate")
async def route_upload_certificate(
    file: UploadFile, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    if not current_user.is_coach:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You need to be a coach to upload a certificate")

    if file.filename is None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="File name is empty")

    if not validate_certificate_name(file.filename):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Only .pdf, .jpg, .jpeg, .png files are allowed")

    file_body = await file.read()

    user_upload_certificate(db, current_user.user_id, file.filename, file_body)


@router.post("/delete-certificate")
def route_delete_certificate(
    certificate_id: str, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    if not current_user.is_coach:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You need to be a coach to delete a certificate")

    certificates = get_user_certificates(db, current_user.user_id)

    if len(certificates) == 1:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You need to have at least one certificate")

    delete_user_certificate(db, current_user.user_id, certificate_id)


@router.get("/get-profile-picture")
def route_get_profile_picture(db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)) -> Response:
    image = get_user_profile_image(db, current_user.user_id)

    if image is None:
        if current_user.gender == Gender.male:
            return FileResponse(os.path.join(config.assets_dir, "avatar_man_image.png"))
        return FileResponse(os.path.join(config.assets_dir, "avatar_woman_image.png"))

    return Response(content=image.body, media_type=_get_api_media_type(image.name))


@router.post("/upload-profile-picture")
async def route_upload_profile_picture(
    file: UploadFile, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    if file.filename is None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="File name is empty")

    if not validate_profile_picture_name(file.filename):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Only .jpg, .jpeg, .png files are allowed")

    file_body = await file.read()

    user_upload_profile_image(db, current_user.user_id, file.filename, file_body)


@router.post("/delete-profile-picture")
def route_delete_profile_picture(db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)) -> None:
    delete_user_profile_image(db, current_user.user_id)


@router.post("/update-details")
def route_update_details(
    new_name: str | None = None,
    new_email: str | None = None,
    new_phone: str | None = None,
    new_gender: Gender | None = None,
    new_description: str | None = None,
    db: psycopg.Connection = Depends(db_dependency),
    current_user: User = Depends(get_current_user),
) -> UserSchema:
    updated_name = current_user.name
    updated_email = current_user.email
    updated_phone = current_user.phone
    updated_gender = current_user.gender
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

    if new_gender is not None:
        updated_gender = new_gender

    if new_description is not None:
        updated_description = new_description

    update_user(db, current_user.user_id, updated_name, updated_email, updated_phone, updated_gender, updated_description)

    user = get_user_by_id(db, current_user.user_id)

    if user is None:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Internal server error")

    return UserSchema.from_model(user)


@router.post("/update-password")
def route_update_password(
    new_password: str, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> UserSchema:
    password_hash = create_hash(new_password)

    update_user_password(db, current_user.user_id, password_hash)

    user = get_user_by_id(db, current_user.user_id)

    if user is None:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Internal server error")

    return UserSchema.from_model(user)
