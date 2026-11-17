import 'package:flutter_test/flutter_test.dart';
import 'package:pm_tugas_07_4243250005/models/college_task.dart';
import 'package:pm_tugas_07_4243250005/state/task_provider.dart';

void main() {
  final dueAt = DateTime(2030, 5, 10, 23, 59);

  test('derived task statistics update after completion changes', () {
    final provider = TaskProvider(
      initialTasks: [
        CollegeTask(
          id: 'active',
          title: 'Review',
          course: 'Mobile',
          dueAt: dueAt,
        ),
        CollegeTask(
          id: 'done',
          title: 'Quiz',
          course: 'Database',
          dueAt: dueAt,
          isCompleted: true,
        ),
      ],
    );
    addTearDown(provider.dispose);

    expect(provider.totalCount, 2);
    expect(provider.activeCount, 1);
    expect(provider.completedCount, 1);
    expect(provider.completionRate, 0.5);

    provider.toggleCompletion('active');

    expect(provider.activeCount, 0);
    expect(provider.completedCount, 2);
    expect(provider.completionRate, 1);
  });

  test('add trims fields and notifies listeners; remove updates totals', () {
    final provider = TaskProvider();
    addTearDown(provider.dispose);
    var notifications = 0;
    provider.addListener(() => notifications++);

    provider.addTask(
      title: '  Project report  ',
      course: '  Research  ',
      dueAt: dueAt,
    );

    expect(provider.totalCount, 1);
    expect(provider.tasks.single.title, 'Project report');
    expect(provider.tasks.single.course, 'Research');
    expect(notifications, 1);

    provider.removeTask(provider.tasks.single.id);

    expect(provider.totalCount, 0);
    expect(provider.completionRate, 0);
    expect(notifications, 2);
  });

  test('rejects empty fields and unknown task IDs', () {
    final provider = TaskProvider();
    addTearDown(provider.dispose);

    expect(
      () => provider.addTask(title: ' ', course: 'Mobile', dueAt: dueAt),
      throwsArgumentError,
    );
    expect(() => provider.toggleCompletion('missing'), throwsStateError);
    expect(() => provider.removeTask('missing'), throwsStateError);
  });
}
