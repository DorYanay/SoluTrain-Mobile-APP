from contextlib import asynccontextmanager
from typing import AsyncIterator

from fastapi import FastAPI
from fastapi.responses import RedirectResponse

from src.config import init_config
from src.logger import get_logger, init_loggers
from src.models import close_db, init_db
from src.routers.auth import router as auth_router
from src.routers.profile import router as profile_router
from src.routers.find_groups import router as find_groups_router
from src.routers.example import router as example_router


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    """Initialize and close the server"""

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

# Include routers
app.include_router(auth_router, prefix="/auth")
app.include_router(profile_router, prefix="/profile")
app.include_router(find_groups_router, prefix="/find-groups")
app.include_router(example_router, prefix="/example")


@app.get("/", include_in_schema=False)
async def root() -> RedirectResponse:
    return RedirectResponse("/docs")
