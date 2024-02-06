@ECHO OFF

REM This script is used to clean up the backend project cache

cd ../backend
del /s /q .pytest_cache
del /s /q .mypy_cache
del /s /q /f *.pyc
del /s /q /f *.pyo
del /s /q /f *~
for /d %%x in (__pycache__) do @rd /s /q "%%x"

pause
