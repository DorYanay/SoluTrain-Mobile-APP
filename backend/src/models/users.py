from enum import IntEnum
from uuid import UUID, uuid4

import psycopg

from src.models import db_named_query


class Gender(IntEnum):
    male = 0
    female = 1


class User:
    user_id: UUID
    name: str
    email: str
    gender: Gender
    description: str

    def __init__(self, user_id: UUID, name: str, email: str, gender: Gender, description: str):
        self.user_id = user_id
        self.name = name
        self.email = email
        self.gender = gender
        self.description = description


@db_named_query
def get_user(db: psycopg.Connection, user_id: UUID) -> User | None:
    with db.cursor() as cursor:
        cursor.execute("SELECT id, name, email, gender, description FROM users WHERE id = %s", [str(user_id)])
        db.commit()

        row = cursor.fetchone()

        if row is None:
            return None

        return User(user_id=UUID(row[0]), name=str(row[1]), email=str(row[2]), gender=Gender(int(row[3])), description=str(row[4]))


@db_named_query
def create_user(db: psycopg.Connection, name: str, email: str, gender: Gender) -> User:
    user_id = uuid4()
    user = User(user_id=user_id, name=name, email=email, gender=gender, description="")

    with db.cursor() as cursor:
        cursor.execute(
            "INSERT INTO public.users (id, name, email, gender, description) VALUES (%s, %s, %s, %s, %s);",
            (str(user.user_id), str(user.name), set(user.email), int(user.gender), str(user.description)),
        )
        db.commit()

    return user
