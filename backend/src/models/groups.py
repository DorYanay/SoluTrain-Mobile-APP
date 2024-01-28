from uuid import UUID, uuid4

import psycopg

from src.models import db_named_query


class Area:
    area_id: UUID
    name: str

    def __init__(self, area_id: UUID, name: str) -> None:
        self.area_id = area_id
        self.name = name


@db_named_query
def create_area(db: psycopg.Connection, name: str) -> Area:
    area_id = uuid4()

    area = Area(
        area_id=area_id,
        name=name,
    )

    with db.cursor() as cursor:
        cursor.execute(
            """INSERT INTO public.areas (id, name)
            VALUES (%s, %s);
            """,
            (
                str(area.area_id),
                str(area.name),
            ),
        )

    return area


@db_named_query
def get_areas(db: psycopg.Connection) -> list[Area]:
    with db.cursor() as cursor:
        cursor.execute("SELECT id, name FROM areas;")
        db.commit()

        rows = cursor.fetchall()

        areas: list[Area] = []

        for row in rows:
            area = Area(
                area_id=row[0],
                name=str(row[1]),
            )

            areas.append(area)

        return areas


class Group:
    group_id: UUID
    trainer_id: UUID
    name: str
    description: str
    area_id: UUID
    city: str
    street: str
    group_type: int

    def __init__(
        self, group_id: UUID, trainer_id: UUID, name: str, description: str, area_id: UUID, city: str, street: str, group_type: int
    ):
        self.group_id = group_id
        self.trainer_id = trainer_id
        self.name = name
        self.description = description
        self.area_id = area_id
        self.city = city
        self.street = street
        self.group_type = group_type


@db_named_query
def create_group(
    db: psycopg.Connection, trainer_id: UUID, name: str, description: str, area_id: UUID, city: str, street: str, group_type: int
) -> Group:
    group_id = uuid4()

    group = Group(
        group_id=group_id,
        trainer_id=trainer_id,
        name=name,
        description=description,
        area_id=area_id,
        city=city,
        street=street,
        group_type=group_type,
    )

    with db.cursor() as cursor:
        cursor.execute(
            """INSERT INTO public.groups (id, trainer_id, name, description, area_id, city, street, group_type)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
            """,
            (
                str(group.group_id),
                str(group.trainer_id),
                str(group.name),
                str(group.description),
                str(group.area_id),
                str(group.city),
                str(group.street),
                int(group.group_type),
            ),
        )

    return group


@db_named_query
def get_groups_by_area_id(db: psycopg.Connection, area_id: UUID) -> list[Group]:
    with db.cursor() as cursor:
        cursor.execute(
            "SELECT id, trainer_id, name, description, area_id, city, street, group_type FROM groups WHERE area_id = %s;",
            [str(area_id)],
        )
        db.commit()

        rows = cursor.fetchall()

        groups: list[Group] = []

        for row in rows:
            group = Group(
                group_id=row[0],
                trainer_id=row[1],
                name=str(row[2]),
                description=str(row[3]),
                area_id=row[4],
                city=str(row[5]),
                street=str(row[6]),
                group_type=int(row[7]),
            )

            groups.append(group)

        return groups


@db_named_query
def add_member_to_group(db: psycopg.Connection, group_id: UUID, user_id: UUID) -> None:
    with db.cursor() as cursor:
        cursor.execute(
            """INSERT INTO public.group_members (group_id, user_id)
            VALUES (%s, %s);
            """,
            (
                str(group_id),
                str(user_id),
            ),
        )
        db.commit()


@db_named_query
def remove_member_from_group(db: psycopg.Connection, group_id: int, user_id: UUID) -> None:
    with db.cursor() as cursor:
        cursor.execute(
            """DELETE FROM public.group_members
            WHERE (group_id = %s AND user_id = %s);
            """,
            (
                str(group_id),
                str(user_id),
            ),
        )
        db.commit()
