import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pm_tugas_07_4243250005/main.dart';
import 'package:pm_tugas_07_4243250005/models/college_task.dart';
import 'package:pm_tugas_07_4243250005/router/app_router.dart';
import 'package:pm_tugas_07_4243250005/state/task_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('filter is local while statistics react to shared state', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final provider = TaskProvider(
      initialTasks: [
        CollegeTask(
          id: 'active',
          title: 'Essay outline',
          course: 'English',
          dueAt: DateTime(2030, 5, 10, 23, 59),
        ),
        CollegeTask(
          id: 'completed',
          title: 'Review chapter',
          course: 'Biology',
          dueAt: DateTime(2030, 5, 11, 23, 59),
          isCompleted: true,
        ),
      ],
    );
    final router = createAppRouter();
    await _pumpPlanner(tester, provider, router);

    expect(find.text('Essay outline'), findsOneWidget);
    expect(find.text('Review chapter'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Aktif'));
    await tester.pumpAndSettle();
    expect(find.text('Essay outline'), findsOneWidget);
    expect(find.text('Review chapter'), findsNothing);
    expect(provider.totalCount, 2);

    await tester.tap(find.text('Statistik'));
    await tester.pumpAndSettle();
    provider.toggleCompletion('active');
    await tester.pumpAndSettle();

    expect(find.text('100%'), findsOneWidget);
    expect(find.text('2 dari 2 tugas sudah selesai.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    provider.dispose();
  });

  testWidgets('form validates and adds a task to the shared list', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final provider = TaskProvider();
    final router = createAppRouter();
    await _pumpPlanner(tester, provider, router);

    await tester.tap(find.text('Tambah').first);
    await tester.pumpAndSettle();
    expect(find.text('Tambah tugas baru'), findsOneWidget);

    await tester.tap(find.text('Simpan tugas'));
    await tester.pumpAndSettle();
    expect(find.text('Judul tugas wajib diisi.'), findsOneWidget);
    expect(find.text('Mata kuliah wajib diisi.'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Judul tugas'),
      'Laporan akhir',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mata kuliah'),
      'Pemrograman Mobile',
    );
    await tester.tap(find.text('Simpan tugas'));
    await tester.pumpAndSettle();

    expect(provider.totalCount, 1);
    expect(find.text('Laporan akhir'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    provider.dispose();
  });
}

Future<void> _pumpPlanner(
  WidgetTester tester,
  TaskProvider provider,
  GoRouter router,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: provider,
      child: PlannerApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
}
