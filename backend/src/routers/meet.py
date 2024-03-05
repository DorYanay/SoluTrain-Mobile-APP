from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status

from src.models import db_dependency
from src.models.groups import delete_meet, get_group_by_id, get_meet, get_meet_members, remove_member_from_meet, update_meet
from src.models.notifications import create_notification
from src.models.users import User
from src.schemas import MeetSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/get-as-coach")
def route_get(meet_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)) -> MeetSchema:
    if not current_user.is_coach:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only coach can get meet")

    meet_data = get_meet(db, meet_id)

    if meet_data is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meet not found")

    meet, coach_id = meet_data

    if coach_id != current_user.user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="You are not the coach of this meet")

    group_data = get_group_by_id(db, meet.group_id)

    if group_data is None:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Internal server error: group not found")

    group = group_data[0]

    members = get_meet_members(db, meet_id)

    return MeetSchema.from_model(meet, group.name, members)


@router.post("/update-details")
def route_update_details(
    meet_id: UUID,
    new_max_members: int | None = None,
    new_date: str | None = None,
    new_duration: int | None = None,
    new_city: str | None = None,
    new_street: str | None = None,
    db: psycopg.Connection = Depends(db_dependency),
    current_user: User = Depends(get_current_user),
) -> None:
    # validation
    if new_max_members is None and new_date is None is None and new_duration is None and new_city is None and new_street is None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="No data to update")

    if not current_user.is_coach:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only coach can update meet")

    meet_data = get_meet(db, meet_id)

    if meet_data is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meet not found")

    meet, coach_id = meet_data

    if coach_id != current_user.user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="You are not the coach of this meet")

    # update
    max_members = meet.max_members
    meet_date = meet.meet_date.strftime("%Y-%m-%d %H:%M:%S")
    duration = meet.duration
    city = meet.city
    street = meet.street

    send_notification = False

    if new_max_members is not None:
        max_members = new_max_members

    if new_date is not None:
        meet_date = new_date
        send_notification = True

    if new_duration is not None:
        duration = new_duration
        send_notification = True

    if new_city is not None:
        city = new_city
        send_notification = True

    if new_street is not None:
        street = new_street
        send_notification = True

    update_meet(db, meet_id, max_members, meet_date, duration, city, street)

    # send notification to the members
    if send_notification:
        members = get_meet_members(db, meet_id)
        for member in members:
            create_notification(db, member.user_id, f"Meet details have been updated by {current_user.name}")

    return None


@router.post("/remove-member")
def route_remove_member(
    meet_id: UUID, member_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> MeetSchema:
    if not current_user.is_coach:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only coach can remove member from meet")

    meet_data = get_meet(db, meet_id)

    if meet_data is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meet not found")

    meet, coach_id = meet_data

    if coach_id != current_user.user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="You are not the coach of this meet")

    group_data = get_group_by_id(db, meet.group_id)

    if group_data is None:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Internal server error: group not found")

    group = group_data[0]

    members = get_meet_members(db, meet_id)

    members_count = len(members)

    members = [member for member in members if member.user_id != member_id]

    if len(members) == members_count:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Member not found in meet")

    remove_member_from_meet(db, meet_id, member_id)

    # send notification to the member
    create_notification(db, member_id, f"You have been removed from meet in {group.name} by {current_user.name}")

    return MeetSchema.from_model(meet, group.name, members)


@router.post("/delete-meet")
def route_delete_meet(
    meet_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    if not current_user.is_coach:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only coach can delete meet")

    meet_data = get_meet(db, meet_id)

    if meet_data is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meet not found")

    meet, coach_id = meet_data

    if coach_id != current_user.user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="You are not the coach of this meet")

    group_data = get_group_by_id(db, meet.group_id)

    if group_data is None:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Internal server error: group not found")

    group = group_data[0]

    members = get_meet_members(db, meet_id)

    delete_meet(db, meet_id)

    # send notification to the members
    for member in members:
        create_notification(db, member.user_id, f"Meet in {group.name} has been deleted by {current_user.name}")
