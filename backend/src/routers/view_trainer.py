import os
from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, Response, status
from fastapi.responses import FileResponse

from src.api import get_api_media_type
from src.config import config
from src.models import db_dependency
from src.models.users import Gender, get_user_by_id, get_user_profile_image
from src.schemas import UserBaseSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/get")
def route_get(trainer_id: UUID, db: psycopg.Connection = Depends(db_dependency)) -> UserBaseSchema:
    trainer = get_user_by_id(db, trainer_id)

    if trainer is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Trainer not found")

    return UserBaseSchema.from_model(trainer)


@router.get("/get-profile-picture")
def route_get_profile_picture(trainer_id: UUID, db: psycopg.Connection = Depends(db_dependency)) -> Response:
    trainer = get_user_by_id(db, trainer_id)

    if trainer is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Trainer not found")

    image = get_user_profile_image(db, trainer_id)

    if image is None:
        if trainer.gender == Gender.male:
            return FileResponse(os.path.join(config.assets_dir, "avatar_man_image.png"))
        return FileResponse(os.path.join(config.assets_dir, "avatar_woman_image.png"))

    return Response(content=image.body, media_type=get_api_media_type(image.name))
