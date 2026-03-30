part of 'task.dart';

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = taskStatusTypeId;

  @override
  TaskStatus read(BinaryReader reader) {
    final int value = reader.readInt();
    switch (value) {
      case 0:
        return TaskStatus.ToDo;
      case 1:
        return TaskStatus.InProgress;
      case 2:
        return TaskStatus.Done;
      default:
        // Fallback for forwards-compatibility with older stored values.
        return TaskStatus.ToDo;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    final int value;
    switch (obj) {
      case TaskStatus.ToDo:
        value = 0;
        break;
      case TaskStatus.InProgress:
        value = 1;
        break;
      case TaskStatus.Done:
        value = 2;
        break;
    }
    writer.writeInt(value);
  }
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = taskTypeId;

  @override
  Task read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      dueDate: fields[3] as DateTime,
      status: fields[4] as TaskStatus,
      blockedByTaskId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.blockedByTaskId);
  }
}

