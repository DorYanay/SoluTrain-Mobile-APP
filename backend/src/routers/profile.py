import psycopg
from fastapi import APIRouter, Depends
from pydantic import BaseModel

from src.models import db_dependency
from src.models.groups import get_coach_groups, get_tariner_groups
from src.models.users import User
from src.schemas import GroupInfoSchema, GroupSchema, UserSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


class ProfileSchema(BaseModel):
    user: UserSchema
    is_coach: bool
    in_groups: list[GroupInfoSchema]
    coach_groups: list[GroupSchema]


@router.post("/get")
def route_get(db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)) -> ProfileSchema:
    in_groups = get_tariner_groups(db, current_user.user_id)
    coach_groups = []

    if current_user.is_coach:
        coach_groups = get_coach_groups(db, current_user.user_id)

    return ProfileSchema(
        user=UserSchema.from_model(current_user),
        is_coach=current_user.is_coach,
        in_groups=[GroupInfoSchema.from_model(row) for row in in_groups],
        coach_groups=[GroupSchema.from_model(group, current_user.name) for group in coach_groups],
    )
