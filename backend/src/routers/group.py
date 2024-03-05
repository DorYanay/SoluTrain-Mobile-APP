from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status

from src.models import db_dependency
from src.models.groups import (
    add_member_to_group,
    add_member_to_meet,
    check_member_in_group,
    check_member_in_meet,
    delete_group,
    delete_meet,
    get_group_by_id,
    get_group_meets,
    get_group_meets_info,
    get_group_members,
    get_meet,
    get_meet_members_count,
    remove_member_from_group,
    remove_member_from_meet,
)
from src.models.notifications import create_notification
from src.models.users import User
from src.schemas import GroupFullSchema, GroupSchema, GroupViewInfoSchema, MeetInfoSchema
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

        meets.append(MeetInfoSchema.from_model(meet, group.name, members_count, registered))

    registered = check_member_in_group(db, group_id, current_user.user_id)

    return GroupViewInfoSchema(group=GroupSchema.from_model(group, coach_name), meets=meets, registered=registered)


@router.post("/get-as-coach")
def route_get_as_coach(
    group_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> GroupFullSchema:
    group_data = get_group_by_id(db, group_id)

    if not group_data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    group, coach_name = group_data

    if group.coach_id != current_user.user_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not the coach of this group")

    meets = get_group_meets(db, group_id)
    members = get_group_members(db, group_id)

    return GroupFullSchema.from_model(group, coach_name, meets, members)


@router.post("/register-to-group")
def route_register_to_group(
    group_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    group_data = get_group_by_id(db, group_id)

    if group_data is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    group, _ = group_data

    if group.coach_id == current_user.user_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are the coach of this group")

    if check_member_in_group(db, group_id, current_user.user_id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are already registered to this group")

    add_member_to_group(db, group_id, current_user.user_id)

    # send notification to the coach
    create_notification(db, group.coach_id, f"{current_user.name} registered to the group {group.name}")

    return None


@router.post("/unregister-to-group")
def route_unregister_to_group(
    group_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    group_data = get_group_by_id(db, group_id)

    if group_data is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    group, _ = group_data

    if group.coach_id == current_user.user_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are the coach of this group")

    if not check_member_in_group(db, group_id, current_user.user_id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not registered to this group")

    remove_member_from_group(db, group_id, current_user.user_id)

    # send notification to the coach
    create_notification(db, group.coach_id, f"{current_user.name} unregistered from the group {group.name}")

    return None


@router.post("/register-to-meet")
def route_register_to_meet(
    meet_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    meet_data = get_meet(db, meet_id)

    if meet_data is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meet not found")

    meet, coach_id = meet_data

    if coach_id == current_user.user_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are the coach of this group")

    if not check_member_in_group(db, meet.group_id, current_user.user_id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not registered to the group")

    if check_member_in_meet(db, meet_id, current_user.user_id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are already registered to this meet")

    meet_full = get_meet_members_count(db, meet_id) >= meet.max_members

    if meet_full:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The meeting is full")

    add_member_to_meet(db, meet_id, current_user.user_id)

    return None


@router.post("/unregister-to-meet")
def route_unregister_to_meet(
    meet_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    meet_data = get_meet(db, meet_id)

    if meet_data is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meet not found")

    meet, coach_id = meet_data

    if coach_id == current_user.user_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are the coach of this group")

    if not check_member_in_group(db, meet.group_id, current_user.user_id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not registered to the group")

    if not check_member_in_meet(db, meet_id, current_user.user_id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not registered to this meet")

    group_data = get_group_by_id(db, meet.group_id)
    if group_data is None:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="internal server error: group not found")

    group = group_data[0]

    remove_member_from_meet(db, meet_id, current_user.user_id)

    # send notification to the coach
    meet_name = meet.meet_date.strftime("%d-%m-%Y %H:%M")
    create_notification(db, coach_id, f"{current_user.name} unregistered from the meet {meet_name} in {group.name}")

    return None


@router.post("/remove-member")
def route_remove_member(
    group_id: UUID, member_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> GroupFullSchema:
    group_data = get_group_by_id(db, group_id)

    if not group_data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    group, coach_name = group_data

    if group.coach_id != current_user.user_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not the coach of this group")

    if not check_member_in_group(db, group_id, member_id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Member not found in the group")

    remove_member_from_group(db, group_id, member_id)

    # send notification to the member
    create_notification(db, member_id, f"You have been removed from the group {group.name} by {current_user.name}")

    return route_get_as_coach(group.group_id, db, current_user)


@router.post("/delete-group")
def route_delete_group(
    group_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    group_data = get_group_by_id(db, group_id)

    if not group_data:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    group, _ = group_data

    if group.coach_id != current_user.user_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not the coach of this group")

    meets = get_group_meets(db, group_id)
    members = get_group_members(db, group_id)

    for meet in meets:
        delete_meet(db, meet.meet_id)

    delete_group(db, group_id)

    # send notification to the members
    for member in members:
        create_notification(db, member.user_id, f"The group {group.name} has been deleted by {current_user.name}")
