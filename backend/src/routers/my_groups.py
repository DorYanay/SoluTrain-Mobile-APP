import psycopg
from fastapi import APIRouter, Depends

from src.models import db_dependency
from src.models.groups import get_coach_groups, get_tariner_groups
from src.models.users import User
from src.schemas import GroupInfoSchema, GroupSchema, MyGroupsSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/get")
def route_get(db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)) -> MyGroupsSchema:
    in_groups = get_tariner_groups(db, current_user.user_id)
    coach_groups = []

    if current_user.is_coach:
        coach_groups = get_coach_groups(db, current_user.user_id)

    return MyGroupsSchema(
        in_groups=[GroupInfoSchema.from_model(row) for row in in_groups],
        coach_groups=[GroupSchema.from_model(group, current_user.name) for group in coach_groups],
    )
