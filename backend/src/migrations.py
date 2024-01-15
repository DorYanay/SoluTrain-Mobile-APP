import psycopg

from src.config import init_config
from src.models import get_db, init_db


def create_database(cursor: psycopg.Cursor) -> None:
    cursor.execute(
        """
        CREATE TABLE public.users (
            id UUID PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            email VARCHAR(255) NOT NULL,
            gender INTEGER NOT NULL,
            description VARCHAR(255) NOT NULL
        );
        """
    )


def migrate_db() -> None:
    init_config()
    init_db()

    with get_db() as db:
        with db.cursor() as cursor:
            create_database(cursor)
        db.commit()
