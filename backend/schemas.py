from datetime import datetime
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, ConfigDict

from .models import TaskStatus


class TaskBase(BaseModel):
    title: str
    description: str
    due_date: datetime
    status: TaskStatus
    blocked_by: Optional[UUID] = None


class TaskCreate(TaskBase):
    pass


class TaskUpdate(TaskBase):
    pass


class TaskOut(BaseModel):
    id: UUID
    title: str
    description: str
    due_date: datetime
    status: TaskStatus
    blocked_by: Optional[UUID] = None

    model_config = ConfigDict(from_attributes=True)

