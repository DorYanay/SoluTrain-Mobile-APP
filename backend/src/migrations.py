import psycopg

from src.config import init_config
from src.models import get_db, init_db


def create_database(cursor: psycopg.Cursor) -> None:
    """Create the database DDL"""

    cursor.execute(
        """
        CREATE TABLE public.users (
            id UUID PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            email VARCHAR(255) NOT NULL,
            password_hash VARCHAR(255) NOT NULL,
            phone VARCHAR(255) NOT NULL,
            gender VARCHAR(10) NOT NULL,
            description VARCHAR(255) NOT NULL,
            is_coach BOOLEAN NOT NULL
        );

        CREATE TABLE notifications (
            id UUID PRIMARY KEY,
            user_id UUID NOT NULL
                REFERENCES public.users (id),
            message VARCHAR(255) NOT NULL,
            date TIMESTAMP NOT NULL
        );

        CREATE TABLE public.profiles (
            id UUID PRIMARY KEY,
            user_id UUID NOT NULL
                REFERENCES public.users (id),
            name VARCHAR(255) NOT NULL,
            body BYTEA NOT NULL
        );

        CREATE TABLE public.certificates (
            id UUID PRIMARY KEY,
            user_id UUID NOT NULL
                REFERENCES public.users (id),
            name VARCHAR(255) NOT NULL,
            body BYTEA NOT NULL
        );

        CREATE TABLE public.areas (
            id UUID PRIMARY KEY,
            name VARCHAR(255) NOT NULL
        );

        CREATE TABLE public.groups (
            id UUID PRIMARY KEY,
            coach_id UUID NOT NULL
                REFERENCES public.users (id),
            name VARCHAR(255) NOT NULL,
            description VARCHAR(255) NOT NULL,
            area_id UUID NOT NULL
                REFERENCES public.areas (id),
            city VARCHAR(255) NOT NULL,
            street VARCHAR(255) NOT NULL
        );

        CREATE TABLE public.group_calendar (
            id UUID PRIMARY KEY,
            group_id UUID NOT NULL
                REFERENCES public.groups (id),
            day_of_week INTEGER NOT NULL,
            day_of_month INTEGER NOT NULL,
            duration INTEGER NOT NULL
        );

        CREATE TABLE public.group_members (
            group_id UUID NOT NULL
                REFERENCES public.groups (id),
            user_id UUID NOT NULL
                REFERENCES public.users (id)
        );

        CREATE TABLE public.meetings (
            id UUID PRIMARY KEY,
            group_id UUID NOT NULL
                REFERENCES public.groups (id),
            max_members INTEGER NOT NULL,
            date TIMESTAMP NOT NULL,
            duration INTEGER NOT NULL,
            location VARCHAR(255) NOT NULL
        );

        CREATE TABLE public.meeting_members (
            meeting_id UUID NOT NULL
                REFERENCES public.meetings (id),
            user_id UUID NOT NULL
                REFERENCES public.users (id)
        );
        """
    )


def migrate_db() -> None:
    """Command to create the database DDL"""

    init_config()
    init_db()

    with get_db() as db:
        with db.cursor() as cursor:
            create_database(cursor)
        db.commit()
