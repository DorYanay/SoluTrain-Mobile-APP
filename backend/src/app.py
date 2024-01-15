from contextlib import asynccontextmanager
from typing import AsyncIterator

from fastapi import FastAPI

from src.config import init_config
from src.logger import get_logger, init_loggers
from src.models import close_db, init_db


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    init_config()
    init_loggers()

    get_logger().info("The server started.")

    init_db()

    yield None

    close_db()

    get_logger().info("The server closed.")


app = FastAPI(
    title="SoluTrain",
    description="SoluTrain API",
    lifespan=lifespan,
)


@app.get("/")
async def root() -> dict:
    return {"message": "Hello World"}
