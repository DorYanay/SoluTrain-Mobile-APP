from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status

from src.models import db_dependency
from src.models.groups import (
    add_member_to_group,
    add_member_to_meet,
    check_member_in_group,
    check_trainer_in_meet,
    get_group_by_id,
    get_group_meets,
    get_group_meets_info,
    get_group_members,
    remove_member_from_group,
)
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

        meets.append(MeetInfoSchema.from_model(meet, members_count, registered))

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

    add_member_to_group(db, group_id, current_user.user_id)

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

    remove_member_from_group(db, group_id, current_user.user_id)

    return None


@router.post("/register-to-meet")
def route_register_to_meet(
    meet_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    coach_id, registered_to_group, registered_to_meet, meet_is_full = check_trainer_in_meet(db, meet_id, current_user.user_id)

    if coach_id is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meet not found")

    if coach_id == current_user.user_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are the coach of this group")

    if not registered_to_group:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not registered to the group")

    if registered_to_meet:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are already registered to this meet")

    if meet_is_full:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The meeting is full")

    add_member_to_meet(db, meet_id, current_user.user_id)

    return None


@router.post("/unregister-to-meet")
def route_unregister_to_meet(
    meet_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    coach_id, registered_to_group, registered_to_meet, _ = check_trainer_in_meet(db, meet_id, current_user.user_id)

    if coach_id is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meet not found")

    if coach_id == current_user.user_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are the coach of this group")

    if not registered_to_group:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not registered to the group")

    if not registered_to_meet:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You are not registered to this meet")

    remove_member_from_group(db, meet_id, current_user.user_id)

    return None
