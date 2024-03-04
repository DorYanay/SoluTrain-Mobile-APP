from datetime import datetime
from uuid import UUID, uuid4

import psycopg

from src.models import db_named_query


class Notification:
    notification_id: UUID
    user_id: UUID
    message: str
    date: datetime

    def __init__(self, notification_id: UUID, user_id: UUID, message: str, date: datetime):
        self.notification_id = notification_id
        self.user_id = user_id
        self.message = message
        self.date = date


@db_named_query
def create_notification(db: psycopg.Connection, user_id: UUID, message: str) -> None:
    notification_id = uuid4()

    notification = Notification(
        notification_id=notification_id,
        user_id=user_id,
        message=message,
        date=datetime.now(),
    )

    with db.cursor() as cursor:
        cursor.execute(
            """INSERT INTO public.notifications (id, user_id, message, date)
            VALUES (%s, %s, %s, %s)""",
            (str(notification.notification_id), str(notification.user_id), str(notification.message), notification.date),
        )

        db.commit()


@db_named_query
def delete_user_notification(db: psycopg.Connection, notification_id: UUID, user_id: UUID) -> None:
    with db.cursor() as cursor:
        cursor.execute(
            """
            DELETE FROM public.notifications
            WHERE (id = %s AND user_id = %s);
            """,
            [str(notification_id), str(user_id)],
        )

        db.commit()


@db_named_query
def get_user_notifications(db: psycopg.Connection, user_id: UUID) -> list[Notification]:
    notifications = []

    with db.cursor() as cursor:
        cursor.execute(
            """
            SELECT id, user_id, message, date
            FROM public.notifications
            WHERE user_id = %s
            ORDER BY date DESC;
            """,
            [str(user_id)],
        )

        db.commit()

        rows = cursor.fetchall()

        for row in rows:
            notification_id, user_id, message, date = row
            notifications.append(Notification(notification_id, user_id, message, date))

    return notifications
