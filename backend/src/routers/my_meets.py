import psycopg
from fastapi import APIRouter, Depends

from src.models import db_dependency
from src.models.groups import get_trainer_meets
from src.models.users import User
from src.schemas import MeetInfoSchema, MyMeetsSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/get")
def route_get(db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)) -> MyMeetsSchema:
    meets_data = get_trainer_meets(db, current_user.user_id)

    meets: list[MeetInfoSchema] = []

    for meet_data in meets_data:
        meet, members_count, registered = meet_data

        meets.append(MeetInfoSchema.from_model(meet, members_count, registered))

    return MyMeetsSchema(
        meets=meets,
    )
