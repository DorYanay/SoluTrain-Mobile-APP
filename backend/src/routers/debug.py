from __future__ import annotations

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status

from src.models import db_dependency
from src.models.debug import debug_set_is_coach
from src.models.users import get_user_by_email
from src.validators import validate_email

router = APIRouter()


@router.post("/make-not-coach")
async def route_debug_make_not_coach(
    email: str,
    db: psycopg.Connection = Depends(db_dependency),
) -> None:
    if not validate_email(email):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid email address")

    if get_user_by_email(db, email) is None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email not found")

    debug_set_is_coach(db, email, False)


@router.post("/make-coach")
async def route_debug_make_coach(
    email: str,
    db: psycopg.Connection = Depends(db_dependency),
) -> None:
    if not validate_email(email):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid email address")

    if get_user_by_email(db, email) is None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email not found")

    debug_set_is_coach(db, email, True)
