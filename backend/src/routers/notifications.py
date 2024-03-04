from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends

from src.models import db_dependency
from src.models.notifications import delete_user_notification, get_user_notifications
from src.models.users import User
from src.schemas import NotificationsSchema
from src.security import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])


@router.post("/get")
def route_get(db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)) -> NotificationsSchema:
    notifications = get_user_notifications(db, current_user.user_id)

    return NotificationsSchema.from_model(notifications)


@router.post("/delete")
def route_delete(
    notification_id: UUID, db: psycopg.Connection = Depends(db_dependency), current_user: User = Depends(get_current_user)
) -> None:
    delete_user_notification(db, notification_id, current_user.user_id)
