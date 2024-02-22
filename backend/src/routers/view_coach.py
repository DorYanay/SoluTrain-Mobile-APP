import os
from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, Response, status
from fastapi.responses import FileResponse

from src.api import get_api_media_type
from src.config import config
from src.models import db_dependency
from src.models.users import Gender, get_user_by_id, get_user_certificate, get_user_certificates, get_user_profile_image
from src.schemas import ViewCoachSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/get")
def route_get(coach_id: UUID, db: psycopg.Connection = Depends(db_dependency)) -> ViewCoachSchema:
    coach = get_user_by_id(db, coach_id)

    if coach is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Coach not found")

    if not coach.is_coach:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Coach not found")

    certificates = get_user_certificates(db, coach_id)

    return ViewCoachSchema.from_model(coach, certificates)


@router.get("/get-certificate")
def route_get_certificate(coach_id: UUID, certificate_id: str, db: psycopg.Connection = Depends(db_dependency)) -> Response:
    coach = get_user_by_id(db, coach_id)

    if coach is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Coach not found")

    if not coach.is_coach:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Coach not found")

    certificate = get_user_certificate(db, coach_id, certificate_id)

    if certificate is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Certificate not found")

    return Response(content=certificate.body, media_type=get_api_media_type(certificate.name))


@router.get("/get-profile-picture")
def route_get_profile_picture(coach_id: UUID, db: psycopg.Connection = Depends(db_dependency)) -> Response:
    coach = get_user_by_id(db, coach_id)

    if coach is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Coach not found")

    if not coach.is_coach:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Coach not found")

    image = get_user_profile_image(db, coach_id)

    if image is None:
        if coach.gender == Gender.male:
            return FileResponse(os.path.join(config.assets_dir, "avatar_man_image.png"))
        return FileResponse(os.path.join(config.assets_dir, "avatar_woman_image.png"))

    return Response(content=image.body, media_type=get_api_media_type(image.name))
