from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends

from src.models import db_dependency
from src.models.users import User
from src.models.groups import Group, get_groups_by_area_id
from src.schemas import GroupSchema
from src.security import get_current_user


router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/get-groups-by-area-id")
def route_get_with_auth(
    area_id: UUID, db: psycopg.Connection = Depends(db_dependency)
) -> list[GroupSchema]:

    groups_data = get_groups_by_area_id(db, area_id)

    return [GroupSchema.from_model(group[0], group[1]) for group in groups_data]
