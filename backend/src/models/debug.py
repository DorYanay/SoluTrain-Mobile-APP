import psycopg

from src.models import db_named_query


@db_named_query
def debug_set_is_coach(db: psycopg.Connection, email: str, is_coach: bool) -> None:
    with db.cursor() as cursor:
        cursor.execute(
            """UPDATE users SET is_coach = %s WHERE email = %s""",
            (
                bool(is_coach),
                str(email),
            ),
        )
        db.commit()
