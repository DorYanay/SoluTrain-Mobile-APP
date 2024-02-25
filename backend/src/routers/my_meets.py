from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status

from src.models import db_dependency
from src.models.groups import get_trainer_meets, check_trainer_in_meet, get_meet
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


@router.post("/get-meeting")
def route_get_meeting(meet_id: UUID,  db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)) -> MeetInfoSchema:
    coach_id, registered_to_group, registered_to_meet, meet_full = check_trainer_in_meet(db, current_user.user_id, meet_id)

    if coach_id is None or not registered_to_group:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meet not found")

    meet = get_meet(db, meet_id, coach_id)

    if meet is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meet not found")

    return MeetInfoSchema.from_model(meet, meet_full, registered_to_meet)
