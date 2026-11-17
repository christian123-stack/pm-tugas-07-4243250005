import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/college_task.dart';
import '../state/task_provider.dart';
import '../widgets/task_card.dart';

enum TaskFilter { all, active, completed }

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  TaskFilter _filter = TaskFilter.all;

  List<CollegeTask> _visibleTasks(List<CollegeTask> tasks) {
    switch (_filter) {
      case TaskFilter.active:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final visibleTasks = _visibleTasks(provider.tasks);
        return CustomScrollView(
          key: const ValueKey('task-list'),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tugas kuliahmu',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Satu langkah kecil untuk kuliah yang lebih teratur.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _ProgressSummary(
                      activeCount: provider.activeCount,
                      completedCount: provider.completedCount,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Daftar tugas',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        _filterChip(context, TaskFilter.all, 'Semua'),
                        _filterChip(context, TaskFilter.active, 'Aktif'),
                        _filterChip(context, TaskFilter.completed, 'Selesai'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (visibleTasks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _filter == TaskFilter.completed
                          ? 'Belum ada tugas yang selesai.'
                          : 'Tidak ada tugas. Tambahkan tugas kuliahmu.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final task = visibleTasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TaskCard(
                        task: task,
                        onToggle: () => context
                            .read<TaskProvider>()
                            .toggleCompletion(task.id),
                        onDelete: () =>
                            context.read<TaskProvider>().removeTask(task.id),
                      ),
                    );
                  }, childCount: visibleTasks.length),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _filterChip(BuildContext context, TaskFilter filter, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _filter == filter,
      onSelected: (_) => setState(() => _filter = filter),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({
    required this.activeCount,
    required this.completedCount,
  });

  final int activeCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            Color.lerp(colorScheme.primary, const Color(0xFF172E52), 0.3)!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tetap fokus, kamu pasti bisa!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$activeCount tugas aktif · $completedCount selesai',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Colors.white.withValues(alpha: 0.88)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
        ],
      ),
    );
  }
}
