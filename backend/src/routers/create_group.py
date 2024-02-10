from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException
from starlette import status

from src.models import db_dependency
from src.models.groups import area_exists, create_group
from src.models.users import User
from src.schemas import GroupSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/create")
def route_create_group(
    name: str,
    description: str,
    area_id: UUID,
    db: psycopg.Connection = Depends(db_dependency),
    user: User = Depends(get_current_user),
) -> GroupSchema:
    if not user.is_coach:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only coach can create group")

    if not area_exists(db, area_id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Area not found")

    group = create_group(db, user.user_id, name, description, area_id)

    return GroupSchema.from_model(group, user.name)
