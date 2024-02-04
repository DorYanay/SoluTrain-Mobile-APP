from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from starlette import status

from src.models import db_dependency
from src.models.groups import create_group
from src.models.users import User
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


class CreateGroupSchema(BaseModel):
    group_id: str


@router.post("/create")
def route_create(
    name: str,
    description: str,
    area_id: UUID,
    city: str,
    street: str,
    db: psycopg.Connection = Depends(db_dependency),
    current_user: User = Depends(get_current_user),
) -> CreateGroupSchema:
    if not current_user.is_coach:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only coaches can create groups")

    group_id = create_group(db, current_user.user_id, name, description, area_id, city, street, current_user.user_id)

    return CreateGroupSchema(group_id=str(group_id))
