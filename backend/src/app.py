from contextlib import asynccontextmanager
from typing import AsyncIterator

from fastapi import FastAPI
from fastapi.responses import RedirectResponse

from src.config import init_config
from src.logger import get_logger, init_loggers
from src.models import close_db, init_db
from src.routers.auth import router as auth_router
from src.routers.groups import router as groups_router
from src.routers.users import router as users_router


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
app.include_router(groups_router, prefix="/groups")
app.include_router(users_router, prefix="/users")


@app.get("/", include_in_schema=False)
async def root() -> RedirectResponse:
    return RedirectResponse("/docs")
