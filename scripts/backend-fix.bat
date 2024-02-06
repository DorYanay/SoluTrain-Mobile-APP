@ECHO OFF

REM This script runs all the formats of backend

cd ../backend
python -m isort src
python -m black src
