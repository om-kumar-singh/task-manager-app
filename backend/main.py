import uvicorn
from fastapi import Depends, FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID

from . import crud
from .database import get_db, init_db
from .schemas import TaskCreate, TaskOut, TaskUpdate


app = FastAPI(title="Task Management API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def on_startup() -> None:
    await init_db()


@app.post("/tasks", response_model=TaskOut, status_code=201)
async def create_task(payload: TaskCreate, db: AsyncSession = Depends(get_db)) -> TaskOut:
    return await crud.create_task(db, payload)


@app.get("/tasks", response_model=list[TaskOut])
async def list_tasks(db: AsyncSession = Depends(get_db)) -> list[TaskOut]:
    return await crud.get_tasks(db)


@app.put("/tasks/{id}", response_model=TaskOut)
async def update_task(
    id: UUID,
    payload: TaskUpdate,
    db: AsyncSession = Depends(get_db),
) -> TaskOut:
    return await crud.update_task(db, id, payload)


@app.delete("/tasks/{id}", status_code=204)
async def delete_task(id: UUID, db: AsyncSession = Depends(get_db)) -> None:
    await crud.delete_task(db, id)
    return None


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok"}


if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)

