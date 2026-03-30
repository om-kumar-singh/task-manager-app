// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

import '../models/task.dart';
import '../services/task_service.dart';

final taskLoadingProvider = StateProvider<bool>((ref) => false);

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>(
  (ref) => TaskNotifier(
    ref: ref,
    service: const TaskService(),
  ),
);

class TaskNotifier extends StateNotifier<List<Task>> {
  final Ref ref;
  final TaskService service;

  bool _isSaving = false;

  TaskNotifier({
    required this.ref,
    required this.service,
  }) : super(const []) {
    Future.microtask(loadTasks);
  }

  Future<void> loadTasks() async {
    try {
      final tasks = service.getAllTasks();
      // Always assign a new list instance.
      state = List<Task>.unmodifiable(tasks);
    } catch (_) {
      state = const [];
    }
  }

  Future<void> addTask(Task task) async {
    await _runWithSavingLock(
      delay: const Duration(seconds: 2),
      action: () => service.addTask(task),
    );
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _runWithSavingLock(
      delay: const Duration(seconds: 2),
      action: () => service.updateTask(task),
    );
    await loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _runWithSavingLock(
      delay: Duration.zero,
      action: () => service.deleteTask(id),
    );
    await loadTasks();
  }

  Future<void> _runWithSavingLock({
    required Duration delay,
    required Future<void> Function() action,
  }) async {
    if (_isSaving) return;

    _isSaving = true;
    ref.read(taskLoadingProvider.notifier).state = true;

    try {
      if (delay != Duration.zero) {
        await Future.delayed(delay);
      }
      await action();
    } finally {
      _isSaving = false;
      ref.read(taskLoadingProvider.notifier).state = false;
    }
  }
}

