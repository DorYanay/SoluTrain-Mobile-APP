from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException
from starlette import status

from src.models import db_dependency
from src.models.groups import get_group_by_id, get_group_meets_info
from src.models.users import User
from src.schemas import GroupSchema, GroupViewInfoSchema, MeetInfoSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/get")
def route_get(
    group_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> GroupViewInfoSchema:
    group_data = get_group_by_id(db, group_id)

    if not group_data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    group, coach_name = group_data

    meets_data = get_group_meets_info(db, group_id, current_user.user_id)

    meets: list[MeetInfoSchema] = []

    for meet_data in meets_data:
        meet, members_count, registered = meet_data

        meets.append(
            MeetInfoSchema(
                meet_id=str(meet.meet_id),
                meet_date=str(meet.meet_date),
                meet_time=str(meet.meet_time),
                duration=meet.duration,
                location=meet.location,
                full=members_count >= meet.max_members,
                registered=registered,
            )
        )

    return GroupViewInfoSchema(group=GroupSchema.from_model(group, coach_name), meets=meets)
