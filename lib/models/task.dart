// ignore_for_file: constant_identifier_names

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

const int taskStatusTypeId = 0;
const int taskTypeId = 1;

@HiveType(typeId: taskStatusTypeId)
enum TaskStatus {
  @HiveField(0)
  ToDo,
  @HiveField(1)
  InProgress,
  @HiveField(2)
  Done,
}

@HiveType(typeId: taskTypeId)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final TaskStatus status;

  @HiveField(5)
  final String? blockedByTaskId;

  Task({
    String? id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.blockedByTaskId,
  }) : id = id ?? const Uuid().v4();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    Object? blockedByTaskId = _blockedByTaskIdNoChange,
  }) {
    final String? resolvedBlockedByTaskId = identical(
      blockedByTaskId,
      _blockedByTaskIdNoChange,
    )
        ? this.blockedByTaskId
        : blockedByTaskId as String?;

    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      blockedByTaskId: resolvedBlockedByTaskId,
    );
  }

  static const Object _blockedByTaskIdNoChange = Object();
}

