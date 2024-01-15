import sys

import uvicorn

from src.app import app
from src.migrations import migrate_db


def main() -> None:
    if len(sys.argv) > 1:
        if sys.argv[1] == "migrate":
            migrate_db()
            return

        if sys.argv[1] != "help":
            print("Unknown command ", sys.argv[1])
            print("")

        print("Usage: python -m src [migrate]")
        print("  migrate: Create the database DDL")
        return

    uvicorn.run(app)


if __name__ == "__main__":
    main()
