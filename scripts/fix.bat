@ECHO OFF

REM This script runs all the formats

cd ../backend
python -m isort src
python -m black src
