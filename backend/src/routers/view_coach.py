from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException
from starlette import status

from src.models import db_dependency
from src.models.users import get_user_by_id
from src.schemas import UserBaseSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/get")
def route_get(coach_id: UUID, db: psycopg.Connection = Depends(db_dependency)) -> UserBaseSchema:
    coach = get_user_by_id(db, coach_id)

    if coach is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Coach not found")

    if not coach.is_coach:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Coach not found")

    return UserBaseSchema.from_model(coach)
