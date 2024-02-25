from enum import StrEnum
from uuid import UUID, uuid4

import psycopg

from src.models import db_named_query


class Gender(StrEnum):
    male = "male"
    female = "female"


class User:
    user_id: UUID
    name: str
    email: str
    password_hash: str
    phone: str
    gender: Gender
    date_of_birth: str
    description: str
    is_coach: bool

    def __init__(
        self,
        user_id: UUID,
        name: str,
        email: str,
        password_hash: str,
        phone: str,
        gender: Gender,
        date_of_birth: str,
        description: str,
        is_coach: bool,
    ):
        self.user_id = user_id
        self.name = name
        self.email = email
        self.password_hash = password_hash
        self.phone = phone
        self.gender = gender
        self.date_of_birth = date_of_birth
        self.description = description
        self.is_coach = is_coach


@db_named_query
def create_user(db: psycopg.Connection, name: str, email: str, password_hash: str, phone: str, gender: Gender, date_of_birth: str) -> User:
    user_id = uuid4()
    user = User(
        user_id=user_id,
        name=name,
        email=email,
        password_hash=password_hash,
        phone=phone,
        gender=gender,
        date_of_birth=date_of_birth,
        description="",
        is_coach=False,
    )

    with db.cursor() as cursor:
        cursor.execute(
            """INSERT INTO public.users (id, name, email, password_hash, phone, gender, date_of_birth, description, is_coach)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);""",
            (
                str(user.user_id),
                str(user.name),
                str(user.email),
                str(user.password_hash),
                str(user.phone),
                str(user.gender),
                str(user.date_of_birth),
                str(user.description),
                bool(user.is_coach),
            ),
        )
        db.commit()

    return user


@db_named_query
def get_user_by_id(db: psycopg.Connection, user_id: UUID) -> User | None:
    with db.cursor() as cursor:
        cursor.execute(
            "SELECT id, name, email, password_hash, phone, gender, date_of_birth, description, is_coach FROM public.users WHERE id = %s",
            [str(user_id)],
        )
        db.commit()

        row = cursor.fetchone()

        if row is None:
            return None

        return User(
            user_id=row[0],
            name=str(row[1]),
            email=str(row[2]),
            password_hash=str(row[3]),
            phone=str(row[4]),
            gender=Gender(str(row[5])),
            date_of_birth=str(row[6]),
            description=str(row[7]),
            is_coach=bool(row[8]),
        )


@db_named_query
def get_user_by_email(db: psycopg.Connection, email: str) -> User | None:
    with db.cursor() as cursor:
        cursor.execute(
            "SELECT id, name, email, password_hash, phone, gender, date_of_birth, description, is_coach FROM public.users WHERE email = %s",
            [str(email)],
        )
        db.commit()

        row = cursor.fetchone()

        if row is None:
            return None

        return User(
            user_id=row[0],
            name=str(row[1]),
            email=str(row[2]),
            password_hash=str(row[3]),
            phone=str(row[4]),
            gender=Gender(str(row[5])),
            date_of_birth=str(row[6]),
            description=str(row[7]),
            is_coach=bool(row[8]),
        )


@db_named_query
def update_user(
    db: psycopg.Connection,
    user_id: UUID,
    updated_name: str,
    updated_email: str,
    updated_phone: str,
    updated_gender: Gender,
    updated_description: str,
) -> None:
    with db.cursor() as cursor:
        cursor.execute(
            "UPDATE public.users SET name = %s, email = %s, phone = %s, gender = %s, description = %s WHERE id = %s",
            [str(updated_name), str(updated_email), str(updated_phone), str(updated_gender), str(updated_description), str(user_id)],
        )
        db.commit()


@db_named_query
def update_user_password(db: psycopg.Connection, user_id: UUID, password_hash: str) -> None:
    with db.cursor() as cursor:
        cursor.execute("UPDATE public.users SET password_hash = %s WHERE id = %s", [password_hash, str(user_id)])
        db.commit()


class FileModel:
    file_id: UUID
    user_id: UUID
    name: str
    body: bytes

    def __init__(self, file_id: UUID, user_id: UUID, name: str, body: bytes):
        self.file_id = file_id
        self.user_id = user_id
        self.name = name
        self.body = body


@db_named_query
def user_upload_certificate(db: psycopg.Connection, user_id: UUID, name: str, body: bytes) -> None:
    file_id = uuid4()
    with db.cursor() as cursor:
        cursor.execute(
            """
            INSERT INTO public.certificates (id, user_id, name, body) VALUES (%s, %s, %s, %s);
            """,
            [str(file_id), str(user_id), name, psycopg.Binary(body)],
        )
        cursor.execute(
            """
            UPDATE public.users SET is_coach = true WHERE id = %s;
            """,
            [str(user_id)],
        )
        db.commit()


@db_named_query
def get_user_certificate(db: psycopg.Connection, user_id: UUID, file_id: UUID) -> FileModel | None:
    with db.cursor() as cursor:
        cursor.execute(
            """
        SELECT id, user_id, name, body FROM public.certificates
        WHERE (id = %s AND user_id = %s)
        """,
            [str(file_id), str(user_id)],
        )
        db.commit()

        row = cursor.fetchone()

        if row is None:
            return None

        return FileModel(file_id=row[0], user_id=row[1], name=str(row[2]), body=row[3])


@db_named_query
def get_user_certificates(db: psycopg.Connection, user_id: UUID) -> list[FileModel]:
    with db.cursor() as cursor:
        cursor.execute("SELECT id, user_id, name FROM public.certificates WHERE user_id = %s", [str(user_id)])
        db.commit()

        rows = cursor.fetchall()

        return [FileModel(file_id=row[0], user_id=row[1], name=str(row[2]), body=b"") for row in rows]


@db_named_query
def delete_user_certificate(db: psycopg.Connection, user_id: UUID, file_id: UUID) -> None:
    with db.cursor() as cursor:
        cursor.execute("DELETE FROM public.certificates WHERE (id = %s AND user_id = %s)", [str(file_id), str(user_id)])
        db.commit()


@db_named_query
def user_upload_profile_image(db: psycopg.Connection, user_id: UUID, name: str, body: bytes) -> None:
    file_id = uuid4()
    with db.cursor() as cursor:
        cursor.execute(
            """
            INSERT INTO public.profiles (id, user_id, name, body) VALUES (%s, %s, %s, %s)
            ON CONFLICT (user_id)
            DO UPDATE SET name = %s, body = %s;
            """,
            [str(file_id), str(user_id), name, psycopg.Binary(body), name, psycopg.Binary(body)],
        )
        db.commit()


@db_named_query
def get_user_profile_image(db: psycopg.Connection, user_id: UUID) -> FileModel | None:
    with db.cursor() as cursor:
        cursor.execute("SELECT id, user_id, name FROM public.profiles WHERE user_id = %s", [str(user_id)])
        db.commit()

        row = cursor.fetchone()

        if row is None:
            return None

        return FileModel(file_id=row[0], user_id=row[1], name=str(row[2]), body=row[3])


@db_named_query
def delete_user_profile_image(db: psycopg.Connection, user_id: UUID) -> None:
    with db.cursor() as cursor:
        cursor.execute("DELETE FROM public.profiles WHERE user_id = %s", [str(user_id)])
        db.commit()
