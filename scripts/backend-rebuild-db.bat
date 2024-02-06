@ECHO OFF

REM This script delete the local database and rebuild it from scratch

docker compose rm -f -s db
docker compose up -d db
sleep 1
cd backend && python -m src migrate

pause
