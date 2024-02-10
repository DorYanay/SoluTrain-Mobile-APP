from uuid import UUID, uuid4

import psycopg

from src.models import db_named_query
from src.models.users import Gender, User


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
        cursor.execute("SELECT id, name FROM public.areas;")
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


@db_named_query
def area_exists(db: psycopg.Connection, area_id: UUID) -> bool:
    with db.cursor() as cursor:
        cursor.execute("SELECT id FROM public.areas WHERE id = %s;", [str(area_id)])
        db.commit()

        row = cursor.fetchone()

        return row is not None


class Group:
    group_id: UUID
    coach_id: UUID
    name: str
    description: str
    area_id: UUID

    def __init__(self, group_id: UUID, coach_id: UUID, name: str, description: str, area_id: UUID):
        self.group_id = group_id
        self.coach_id = coach_id
        self.name = name
        self.description = description
        self.area_id = area_id


@db_named_query
def create_group(db: psycopg.Connection, coach_id: UUID, name: str, description: str, area_id: UUID) -> Group:
    group_id = uuid4()

    group = Group(
        group_id=group_id,
        coach_id=coach_id,
        name=name,
        description=description,
        area_id=area_id,
    )

    with db.cursor() as cursor:
        cursor.execute(
            """INSERT INTO public.groups (id, coach_id, name, description, area_id)
            VALUES (%s, %s, %s, %s, %s);
            """,
            (
                str(group.group_id),
                str(group.coach_id),
                str(group.name),
                str(group.description),
                str(group.area_id),
            ),
        )

    return group


@db_named_query
def get_group_by_id(db: psycopg.Connection, group_id: UUID) -> tuple[Group, str] | None:
    with db.cursor() as cursor:
        cursor.execute(
            """
            SELECT g.id, g.coach_id, g.name, g.description, g.area_id, coach.name
            FROM public.groups AS g
            JOIN public.users AS coach ON g.coach_id = coach.id
            WHERE g.id = %s;
            """,
            [str(group_id)],
        )
        db.commit()

        row = cursor.fetchone()

        if row is None:
            return None

        group = Group(
            group_id=row[0],
            coach_id=row[1],
            name=str(row[2]),
            description=str(row[3]),
            area_id=row[4],
        )

        coach_name = str(row[5])

        return group, coach_name


@db_named_query
def get_groups_by_area_id(db: psycopg.Connection, area_id: UUID) -> list[tuple[Group, str]]:
    """Return list of groups with coach name. By area_id"""
    with db.cursor() as cursor:
        cursor.execute(
            """
            SELECT g.id, g.coach_id, g.name, g.description, g.area_id, coach.name
            FROM public.groups AS g
            JOIN public.users AS coach ON g.coach_id = coach.id
            WHERE area_id = %s;
            """,
            [str(area_id)],
        )
        db.commit()

        rows = cursor.fetchall()

        groups: list[tuple[Group, str]] = []

        for row in rows:
            group = Group(
                group_id=row[0],
                coach_id=row[1],
                name=str(row[2]),
                description=str(row[3]),
                area_id=row[4],
            )

            coach_name = str(row[5])

            groups.append((group, coach_name))

        return groups


@db_named_query
def get_tariner_groups(db: psycopg.Connection, trainer_id: UUID) -> list[tuple[UUID, str, str, str]]:
    """
    Return list of info on groups of trainer.
    Each row contain group_id, coach_name, group_name, area_name
    """
    with db.cursor() as cursor:
        cursor.execute(
            """
            SELECT g.id, coach.name, g.name, a.name
            FROM public.groups_member AS gm
            JOIN public.groups AS g ON gm.group_id = g.id
            JOIN public.users AS coach ON g.coach_id = coach.id
            JOIN public.areas AS a ON g.area_id = a.id
            WHERE gm.user_id = %s;
            """,
            [str(trainer_id)],
        )
        db.commit()

        rows = cursor.fetchall()

        data_rows: list[tuple[UUID, str, str, str]] = []

        for row in rows:
            data = (UUID(row[0]), str(row[1]), str(row[2]), str(row[3]))

            data_rows.append(data)

        return data_rows


@db_named_query
def get_coach_groups(db: psycopg.Connection, coach_id: UUID) -> list[Group]:
    """Return list of groups of coach"""

    with db.cursor() as cursor:
        cursor.execute(
            """
            SELECT g.id, g.coach_id, g.name, g.description, g.area_id
            FROM public.groups AS g
            WHERE coach_id = %s;
            """,
            [str(coach_id)],
        )
        db.commit()

        rows = cursor.fetchall()

        groups: list[Group] = []

        for row in rows:
            group = Group(
                group_id=row[0],
                coach_id=row[1],
                name=str(row[2]),
                description=str(row[3]),
                area_id=row[4],
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


class Meet:
    meet_id: UUID
    group_id: UUID
    max_members: int
    meet_date: str
    duration: int
    city: str
    street: str

    def __init__(self, meet_id: UUID, group_id: UUID, max_members: int, meet_date: str, duration: int, city: str, street: str):
        self.meet_id = meet_id
        self.group_id = group_id
        self.max_members = max_members
        self.meet_date = meet_date
        self.duration = duration
        self.city = city
        self.street = street


@db_named_query
def create_meet(db: psycopg.Connection, group_id: UUID, max_members: int, meet_date: str, duration: int, city: str, street: str) -> Meet:
    meet_id = uuid4()

    meet = Meet(
        meet_id=meet_id,
        group_id=group_id,
        max_members=max_members,
        meet_date=meet_date,
        duration=duration,
        city=city,
        street=street,
    )

    with db.cursor() as cursor:
        cursor.execute(
            """INSERT INTO public.meetings (id, group_id, max_members, date, duration, city, street)
            VALUES (%s, %s, %s, %s, %s, %s);
            """,
            (
                str(meet.meet_id),
                str(meet.group_id),
                int(meet.max_members),
                str(meet.meet_date),
                int(meet.duration),
                str(meet.city),
                str(meet.street),
            ),
        )

    return meet


@db_named_query
def update_meet(db: psycopg.Connection, meet_id: UUID, max_members: int, meet_date: str, duration: int, city: str, street: str) -> None:
    with db.cursor() as cursor:
        cursor.execute(
            """UPDATE public.meetings
            SET max_members = %s, date = %s, duration = %s, city = %s, street = %s
            WHERE id = %s;
            """,
            (
                int(max_members),
                str(meet_date),
                int(duration),
                str(city),
                str(street),
                str(meet_id),
            ),
        )
        db.commit()


@db_named_query
def add_member_to_meet(db: psycopg.Connection, meet_id: UUID, user_id: UUID) -> None:
    with db.cursor() as cursor:
        cursor.execute(
            """INSERT INTO public.meeting_members (meeting_id, user_id)
            VALUES (%s, %s);
            """,
            (
                str(meet_id),
                str(user_id),
            ),
        )
        db.commit()


@db_named_query
def remove_member_from_meet(db: psycopg.Connection, meet_id: int, user_id: UUID) -> None:
    with db.cursor() as cursor:
        cursor.execute(
            """DELETE FROM public.meeting_members
            WHERE (meeting_id = %s AND user_id = %s);
            """,
            (
                str(meet_id),
                str(user_id),
            ),
        )
        db.commit()


@db_named_query
def get_meet(db: psycopg.Connection, meet_id: UUID, coach_id: UUID) -> Meet | None:
    with db.cursor() as cursor:
        cursor.execute(
            """
            SELECT m.id, m.group_id, m.max_members, m.date, m.duration, m.city, m.street
            FROM public.meetings AS m
            JOIN public.groups AS g ON m.group_id = g.id
            WHERE (m.id = %s AND g.coach_id = %s);
            """,
            (str(meet_id), str(coach_id)),
        )
        db.commit()

        row = cursor.fetchone()

        if row is None:
            return None

        meet = Meet(
            meet_id=row[0],
            group_id=row[1],
            max_members=row[2],
            meet_date=row[3],
            duration=row[4],
            city=row[5],
            street=row[6],
        )

        return meet


@db_named_query
def get_meet_members(db: psycopg.Connection, meet_id: UUID) -> list[User]:
    with db.cursor() as cursor:
        cursor.execute(
            """
            SELECT u.id, u.name, u.email, u.password_hash, u.phone, u.gender, u.date_of_birth, u.description, u.is_coach
            FROM public.users AS u
            JOIN public.meeting_members AS mm ON u.id = mm.user_id
            WHERE mm.meeting_id = %s;
            """,
            [str(meet_id)],
        )
        db.commit()

        rows = cursor.fetchall()

        members: list[User] = []

        for row in rows:
            member = User(
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

            members.append(member)

        return members


@db_named_query
def check_trainer_in_meet(db: psycopg.Connection, trainer_id: UUID, meet_id: UUID) -> tuple[UUID | None, bool, bool, bool]:
    """
    Return 4 values.
    First is coach_id if exits meet, None otherwise.
    Second is True if trainer is registered to group, False otherwise.
    Third is True if trainer is registered to meet, False otherwise.
    Fourth is True if meet is full, False otherwise.
    """
    with db.cursor() as cursor:
        cursor.execute(
            """
            SELECT g.coach_id, gm.user_id, mm.user_id, COUNT(mm2.user_id) >= m.max_members
            FROM public.meetings AS m
            JOIN public.groups AS g ON m.group_id = g.id
            LEFT JOIN public.groups_member AS gm ON g.id = gm.group_id
            LEFT JOIN public.meeting_members AS mm ON m.id = mm.meeting_id
            LEFT JOIN public.meeting_members AS mm2 ON m.id = mm2.meeting_id
            GROUP BY m.id
            WHERE (m.id = %s
                    AND (gm.user_id = %s OR gm.user_id IS NULL)
                    AND (mm.user_id = %s OR mm.user_id IS NULL)
                    );
            """,
            (str(meet_id), str(trainer_id), str(trainer_id)),
        )
        db.commit()

        row = cursor.fetchone()

        if row is None:
            return None, False, False, False

        coach_id = UUID(row[0])
        registered_to_group = row[1] is not None
        registered_to_meet = row[2] is not None
        meet_is_full = row[3]

        return coach_id, registered_to_group, registered_to_meet, meet_is_full


@db_named_query
def get_group_meets_info(db: psycopg.Connection, group_id: UUID, user_id: UUID) -> list[tuple[Meet, bool, bool]]:
    with db.cursor() as cursor:
        cursor.execute(
            """
            SELECT m.id, m.date, m.duration, m.city, m.street, m.max_members, COUNT(mm.user_id), mm2.user_id
            FROM public.meetings AS m
            LEFT JOIN public.meeting_members AS mm ON m.id = mm.meeting_id
            LEFT JOIN public.meeting_members AS mm2 ON m.id = mm2.meeting_id
            GROUP BY m.id
            WHERE (m.group_id = %s AND (mm2.user_id = %s OR mm2.user_id IS NULL));
            """,
            (str(user_id), str(group_id)),
        )
        db.commit()

        rows = cursor.fetchall()

        meets: list[tuple[Meet, bool, bool]] = []

        for row in rows:
            meet = Meet(
                meet_id=row[0],
                group_id=group_id,
                max_members=row[5],
                meet_date=row[1],
                duration=row[2],
                city=row[3],
                street=row[4],
            )

            registered = row[7] is not None
            full = row[6] >= row[5]

            meets.append((meet, full, registered))

        return meets


@db_named_query
def get_trainer_meets(db: psycopg.Connection, user_id: UUID) -> list[tuple[Meet, bool, bool]]:
    with db.cursor() as cursor:
        cursor.execute(
            """
            SELECT m.id, m.group_id, m.date, m.duration, m.city, m.street, m.max_members, COUNT(mm.user_id), mm2.user_id
            FROM public.meetings AS m
            LEFT JOIN public.meeting_members AS mm ON m.id = mm.meeting_id
            LEFT JOIN public.meeting_members AS mm2 ON m.id = mm2.meeting_id
            GROUP BY m.id
            WHERE (mm2.user_id = %s);
            """,
            [str(user_id)],
        )
        db.commit()

        rows = cursor.fetchall()

        meets: list[tuple[Meet, bool, bool]] = []

        for row in rows:
            meet = Meet(
                meet_id=row[0],
                group_id=row[1],
                max_members=row[6],
                meet_date=row[2],
                duration=row[3],
                city=row[4],
                street=row[5],
            )

            registered = row[8] is not None
            full = row[7] >= row[6]

            meets.append((meet, full, registered))

        return meets
