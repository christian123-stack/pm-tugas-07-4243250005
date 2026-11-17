import '../models/college_task.dart';

List<CollegeTask> createSampleTasks() {
  final now = DateTime.now();
  return [
    CollegeTask(
      id: 'task-mobile-01',
      title: 'Rancang alur navigasi aplikasi',
      course: 'Pemrograman Mobile',
      dueAt: now.add(const Duration(days: 1)),
    ),
    CollegeTask(
      id: 'task-mobile-02',
      title: 'Kumpulkan referensi jurnal',
      course: 'Metodologi Penelitian',
      dueAt: now.add(const Duration(days: 2)),
    ),
    CollegeTask(
      id: 'task-mobile-03',
      title: 'Latihan query JOIN',
      course: 'Basis Data',
      dueAt: now.add(const Duration(days: 3)),
      isCompleted: true,
    ),
  ];
}
