import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskService {
  static const String _boxName = 'tasks';

  const TaskService();

  List<Task> getAllTasks() {
    if (!Hive.isBoxOpen(_boxName)) return const [];
    return Hive.box<Task>(_boxName).values.toList(growable: false);
  }

  Future<void> addTask(Task task) async {
    final box = await _openBox();
    await box.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    final box = await _openBox();
    await box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<Box<Task>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Task>(_boxName);
    }
    return Hive.openBox<Task>(_boxName);
  }
}

