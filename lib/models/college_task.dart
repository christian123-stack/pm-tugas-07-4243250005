import 'package:flutter/foundation.dart';

@immutable
class CollegeTask {
  const CollegeTask({
    required this.id,
    required this.title,
    required this.course,
    required this.dueAt,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String course;
  final DateTime dueAt;
  final bool isCompleted;

  CollegeTask copyWith({bool? isCompleted}) {
    return CollegeTask(
      id: id,
      title: title,
      course: course,
      dueAt: dueAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
