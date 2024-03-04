from __future__ import annotations

from datetime import timedelta
from uuid import UUID

from pydantic import BaseModel

from src.models.groups import Area, Group, Meet
from src.models.notifications import Notification
from src.models.users import FileModel, Gender, User


class UserBaseSchema(BaseModel):
    user_id: str
    name: str
    email: str
    phone: str
    gender: Gender
    date_of_birth: str
    description: str

    @staticmethod
    def from_model(user: User) -> UserBaseSchema:
        return UserBaseSchema(
            user_id=str(user.user_id),
            name=user.name,
            email=user.email,
            phone=user.phone,
            gender=user.gender,
            date_of_birth=user.date_of_birth,
            description=user.description,
        )


class UserSchema(BaseModel):
    """User schema for the API"""

    user_id: str
    name: str
    email: str
    phone: str
    gender: Gender
    date_of_birth: str
    description: str
    is_coach: bool

    @staticmethod
    def from_model(user: User) -> UserSchema:
        return UserSchema(
            user_id=str(user.user_id),
            name=user.name,
            email=user.email,
            phone=user.phone,
            gender=user.gender,
            date_of_birth=user.date_of_birth,
            description=user.description,
            is_coach=user.is_coach,
        )


class FileSchema(BaseModel):
    file_id: str
    name: str

    @staticmethod
    def from_model(file: FileModel) -> FileSchema:
        return FileSchema(
            file_id=str(file.file_id),
            name=file.name,
        )


class CertificatesSchema(BaseModel):
    certificates: list[FileSchema]

    @staticmethod
    def from_model(certificates: list[FileModel]) -> CertificatesSchema:
        return CertificatesSchema(
            certificates=[FileSchema.from_model(certificate) for certificate in certificates],
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
    coach_id: str
    coach_name: str
    name: str
    description: str
    area_id: str

    @staticmethod
    def from_model(group: Group, coach_name: str) -> GroupSchema:
        return GroupSchema(
            group_id=str(group.group_id),
            coach_id=str(group.coach_id),
            coach_name=coach_name,
            name=group.name,
            description=group.description,
            area_id=str(group.area_id),
        )


class GroupInfoSchema(BaseModel):
    group_id: str
    coach_name: str
    name: str
    area_name: str

    @staticmethod
    def from_model(row: tuple[UUID, str, str, str]) -> GroupInfoSchema:
        return GroupInfoSchema(
            group_id=str(row[0]),
            coach_name=row[1],
            name=row[2],
            area_name=row[3],
        )


class MeetSchema(BaseModel):
    meet_id: str
    group_id: str
    group_name: str
    max_members: int
    meet_date: str
    start_time: str
    end_time: str
    duration: int
    city: str
    street: str

    members: list[UserBaseSchema]

    @staticmethod
    def from_model(meet: Meet, group_name: str, members: list[User]) -> MeetSchema:
        end_time = meet.meet_date + timedelta(minutes=meet.duration)

        return MeetSchema(
            meet_id=str(meet.meet_id),
            group_id=str(meet.group_id),
            group_name=group_name,
            max_members=meet.max_members,
            meet_date=meet.meet_date.date().strftime("%Y-%m-%d %H:%M:%S"),
            start_time=meet.meet_date.time().strftime("%Y-%m-%d %H:%M:%S"),
            end_time=end_time.time().strftime("%Y-%m-%d %H:%M:%S"),
            duration=meet.duration,
            city=meet.city,
            street=meet.street,
            members=[UserBaseSchema.from_model(member) for member in members],
        )


class MeetInfoSchema(BaseModel):
    meet_id: str
    group_id: str
    group_name: str
    meet_date: str
    start_time: str
    end_time: str
    duration: int
    city: str
    street: str
    full: bool
    registered: bool

    @staticmethod
    def from_model(meet: Meet, group_name: str, full: bool, registered: bool) -> MeetInfoSchema:
        end_time = meet.meet_date + timedelta(minutes=meet.duration)

        return MeetInfoSchema(
            meet_id=str(meet.meet_id),
            group_id=str(meet.group_id),
            group_name=group_name,
            meet_date=meet.meet_date.date().strftime("%Y-%m-%d %H:%M:%S"),
            start_time=meet.meet_date.time().strftime("%Y-%m-%d %H:%M:%S"),
            end_time=end_time.time().strftime("%Y-%m-%d %H:%M:%S"),
            duration=meet.duration,
            city=meet.city,
            street=meet.street,
            full=full,
            registered=registered,
        )


class GroupViewInfoSchema(BaseModel):
    group: GroupSchema
    meets: list[MeetInfoSchema]
    registered: bool


class GroupFullSchema(BaseModel):
    group: GroupSchema
    meets: list[MeetSchema]
    members: list[UserBaseSchema]

    @staticmethod
    def from_model(group: Group, coach_name: str, meets: list[Meet], members: list[User]) -> GroupFullSchema:
        return GroupFullSchema(
            group=GroupSchema.from_model(group, coach_name),
            meets=[MeetSchema.from_model(meet, group.name, []) for meet in meets],
            members=[UserBaseSchema.from_model(member) for member in members],
        )


class MeetViewInfoSchema(BaseModel):
    group: GroupSchema
    meet: MeetInfoSchema


class MyGroupsSchema(BaseModel):
    in_groups: list[GroupInfoSchema]
    coach_groups: list[GroupSchema]


class MyMeetsSchema(BaseModel):
    meets: list[MeetInfoSchema]


class ViewCoachSchema(BaseModel):
    coach: UserBaseSchema
    certificates: list[FileSchema]

    @staticmethod
    def from_model(coach: User, certificates: list[FileModel]) -> ViewCoachSchema:
        return ViewCoachSchema(
            coach=UserBaseSchema.from_model(coach),
            certificates=[FileSchema.from_model(certificate) for certificate in certificates],
        )


class NotificationSchema(BaseModel):
    notification_id: str
    message: str
    date: str

    @staticmethod
    def from_model(notification: Notification) -> NotificationSchema:
        return NotificationSchema(
            notification_id=str(notification.notification_id),
            message=notification.message,
            date=notification.date.strftime("%Y-%m-%d %H:%M:%S"),
        )


class NotificationsSchema(BaseModel):
    notifications: list[NotificationSchema]

    @staticmethod
    def from_model(notifications: list[Notification]) -> NotificationsSchema:
        return NotificationsSchema(
            notifications=[NotificationSchema.from_model(notification) for notification in notifications],
        )
