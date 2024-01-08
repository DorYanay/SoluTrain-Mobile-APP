from fastapi import FastAPI

app = FastAPI(
    title="SoluTrain",
    description="SoluTrain API",
)


@app.get("/")
async def root() -> dict:
    return {"message": "Hello World test"}
