import 'package:go_router/go_router.dart';

import '../screens/app_shell.dart';
import '../screens/task_form_page.dart';
import '../screens/task_list_page.dart';
import '../screens/task_statistics_page.dart';

GoRouter createAppRouter() {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const TaskListPage()),
          GoRoute(
            path: '/tambah',
            builder: (context, state) => const TaskFormPage(),
          ),
          GoRoute(
            path: '/statistik',
            builder: (context, state) => const TaskStatisticsPage(),
          ),
        ],
      ),
    ],
  );
}
