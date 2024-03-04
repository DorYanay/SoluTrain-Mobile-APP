from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status

from src.models import db_dependency
from src.models.groups import create_meet, get_group_by_id, get_group_members
from src.models.notifications import create_notification
from src.models.users import User
from src.schemas import MeetSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/create")
def route_create_meet(
    group_id: UUID,
    max_members: int,
    meet_date: str,
    duration: int,
    city: str,
    street: str,
    db: psycopg.Connection = Depends(db_dependency),
    user: User = Depends(get_current_user),
) -> MeetSchema:
    if not user.is_coach:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only coach can create meet")

    group_data = get_group_by_id(db, group_id)

    if group_data is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    group = group_data[0]

    if group.coach_id != user.user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only coach of the group can create meet")

    meet = create_meet(db, group_id, max_members, meet_date, duration, city, street)

    # Send notifications
    group_members = get_group_members(db, group_id)
    for member in group_members:
        create_notification(db, member.user_id, f"New Meet in {group.name} has been created by {user.name}!")

    return MeetSchema.from_model(meet, group.name, [])
