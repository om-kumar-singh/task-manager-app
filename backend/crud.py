import asyncio
from uuid import UUID, uuid4

from fastapi import HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from .models import Task
from .schemas import TaskCreate, TaskUpdate


async def get_tasks(db: AsyncSession) -> list[Task]:
    result = await db.execute(select(Task).order_by(Task.due_date.asc()))
    return list(result.scalars().all())


async def _validate_blocked_by(db: AsyncSession, blocked_by: UUID | None) -> str | None:
    if blocked_by is None:
        return None

    blocked_by_str = str(blocked_by)
    blocker = await db.get(Task, blocked_by_str)
    if blocker is None:
        raise HTTPException(
            status_code=400,
            detail="blocked_by references a task that does not exist",
        )
    return blocked_by_str


async def create_task(db: AsyncSession, task_in: TaskCreate) -> Task:
    await asyncio.sleep(2)

    blocked_by_str = await _validate_blocked_by(db, task_in.blocked_by)

    task = Task(
        id=str(uuid4()),
        title=task_in.title,
        description=task_in.description,
        due_date=task_in.due_date,
        status=task_in.status,
        blocked_by=blocked_by_str,
    )
    db.add(task)
    await db.commit()
    await db.refresh(task)
    return task


async def update_task(db: AsyncSession, task_id: UUID, task_in: TaskUpdate) -> Task:
    existing = await db.get(Task, str(task_id))
    if existing is None:
        raise HTTPException(status_code=404, detail="Task not found")

    await asyncio.sleep(2)
    blocked_by_str = await _validate_blocked_by(db, task_in.blocked_by)

    existing.title = task_in.title
    existing.description = task_in.description
    existing.due_date = task_in.due_date
    existing.status = task_in.status
    existing.blocked_by = blocked_by_str

    db.add(existing)
    await db.commit()
    await db.refresh(existing)
    return existing


async def delete_task(db: AsyncSession, task_id: UUID) -> None:
    existing = await db.get(Task, str(task_id))
    if existing is None:
        raise HTTPException(status_code=404, detail="Task not found")

    await db.delete(existing)
    await db.commit()

