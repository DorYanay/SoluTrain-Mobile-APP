from __future__ import annotations

from uuid import UUID

from pydantic import BaseModel

from src.models.groups import Area, Group, Meet
from src.models.users import Gender, User


class UserBaseSchema(BaseModel):
    user_id: str
    name: str


class UserSchema(BaseModel):
    """User schema for the API"""

    user_id: str
    name: str
    email: str
    phone: str
    gender: Gender
    description: str
    is_trainer: bool
    is_coach: bool

    @staticmethod
    def from_model(user: User) -> UserSchema:
        return UserSchema(
            user_id=str(user.user_id),
            name=user.name,
            email=user.email,
            phone=user.phone,
            gender=user.gender,
            description=user.description,
            is_trainer=user.is_trainer,
            is_coach=user.is_coach,
        )


class AreaSchema(BaseModel):
    area_id: str
    name: str

    @staticmethod
    def from_model(area: Area) -> AreaSchema:
        return AreaSchema(
            area_id=str(area.area_id),
            name=area.name,
        )


class LoginResponseSchema(BaseModel):
    auth_token: UUID
    user: UserSchema
    areas: list[AreaSchema]


class GroupSchema(BaseModel):
    group_id: str
    trainer_id: str
    trainer_name: str
    name: str
    description: str
    area_id: str
    city: str
    street: str

    @staticmethod
    def from_model(group: Group, trainer_name: str) -> GroupSchema:
        return GroupSchema(
            group_id=str(group.group_id),
            trainer_id=str(group.trainer_id),
            trainer_name=trainer_name,
            name=group.name,
            description=group.description,
            area_id=str(group.area_id),
            city=group.city,
            street=group.street,
        )


class MeetSchema(BaseModel):
    meet_id: str
    group_id: str
    max_numbers: int
    meet_date: str
    meet_time: str
    duration: int
    location: str

    members: list[UserBaseSchema]

    @staticmethod
    def from_model(meet: Meet, members: list[UserBaseSchema]) -> MeetSchema:
        return MeetSchema(
            meet_id=str(meet.meet_id),
            group_id=str(meet.group_id),
            max_numbers=meet.max_numbers,
            meet_date=str(meet.meet_date),
            meet_time=str(meet.meet_time),
            duration=meet.duration,
            location=meet.location,
            members=members,
        )
