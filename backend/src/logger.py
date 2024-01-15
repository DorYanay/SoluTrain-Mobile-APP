import logging
import logging.config
from logging.config import dictConfig

from src.config import config


def init_loggers() -> None:
    logger_config = {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "default": {
                "()": "uvicorn.logging.DefaultFormatter",
                "fmt": "%(levelprefix)s %(message)s",
                "datefmt": "%Y-%m-%d %H:%M:%S",
            },
        },
        "handlers": {
            "default": {
                "formatter": "default",
                "class": "logging.StreamHandler",
                "stream": "ext://sys.stderr",
            },
        },
        "loggers": {
            "app": {"handlers": ["default"], "level": "DEBUG"},
        },
    }

    dictConfig(logger_config)

    logging.getLogger("app").setLevel(config.logger_level)
    logging.getLogger("psycopg").setLevel("ERROR")
    logging.getLogger("psycopg.pool").setLevel("ERROR")


def get_logger() -> logging.Logger:
    return logging.getLogger("app")
