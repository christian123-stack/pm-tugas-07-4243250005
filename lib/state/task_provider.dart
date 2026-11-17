import 'package:flutter/foundation.dart';

import '../models/college_task.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider({Iterable<CollegeTask> initialTasks = const []})
    : _tasks = List<CollegeTask>.of(initialTasks);

  final List<CollegeTask> _tasks;
  int _nextId = 0;

  List<CollegeTask> get tasks => List<CollegeTask>.unmodifiable(_tasks);

  int get totalCount => _tasks.length;

  int get completedCount => _tasks.where((task) => task.isCompleted).length;

  int get activeCount => totalCount - completedCount;

  double get completionRate =>
      totalCount == 0 ? 0 : completedCount / totalCount;

  void addTask({
    required String title,
    required String course,
    required DateTime dueAt,
  }) {
    final trimmedTitle = title.trim();
    final trimmedCourse = course.trim();
    if (trimmedTitle.isEmpty) {
      throw ArgumentError.value(
        title,
        'title',
        'Judul tugas tidak boleh kosong.',
      );
    }
    if (trimmedCourse.isEmpty) {
      throw ArgumentError.value(
        course,
        'course',
        'Mata kuliah tidak boleh kosong.',
      );
    }

    _tasks.add(
      CollegeTask(
        id: '${DateTime.now().microsecondsSinceEpoch}-${_nextId++}',
        title: trimmedTitle,
        course: trimmedCourse,
        dueAt: dueAt,
      ),
    );
    _tasks.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    notifyListeners();
  }

  void toggleCompletion(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      throw StateError('Tugas dengan ID "$id" tidak ditemukan.');
    }
    _tasks[index] = _tasks[index].copyWith(
      isCompleted: !_tasks[index].isCompleted,
    );
    notifyListeners();
  }

  void removeTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      throw StateError('Tugas dengan ID "$id" tidak ditemukan.');
    }
    _tasks.removeAt(index);
    notifyListeners();
  }
}
