FROM python:3.11

RUN pip install -U pip poetry==1.7.1

WORKDIR /app

COPY . .

RUN poetry config virtualenvs.create false
RUN poetry install

EXPOSE 8000

CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8000"]
