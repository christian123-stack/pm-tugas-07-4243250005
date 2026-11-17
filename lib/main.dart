import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'data/sample_tasks.dart';
import 'router/app_router.dart';
import 'state/task_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(initialTasks: createSampleTasks()),
      child: PlannerApp(router: createAppRouter()),
    ),
  );
}

class PlannerApp extends StatelessWidget {
  const PlannerApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF315C9B),
      brightness: Brightness.light,
    );

    return MaterialApp.router(
      title: 'Rencana Kuliah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7FA),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE7EAF0)),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
