import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/task_provider.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  int get _selectedIndex {
    if (location.startsWith('/tambah')) return 1;
    if (location.startsWith('/statistik')) return 2;
    return 0;
  }

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 1:
        context.go('/tambah');
      case 2:
        context.go('/statistik');
      default:
        context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = context.select<TaskProvider, int>(
      (provider) => provider.activeCount,
    );
    final destinations = [
      const NavigationDestination(
        icon: Icon(Icons.checklist_outlined),
        selectedIcon: Icon(Icons.checklist),
        label: 'Tugas',
      ),
      const NavigationDestination(
        icon: Icon(Icons.add_circle_outline),
        selectedIcon: Icon(Icons.add_circle),
        label: 'Tambah',
      ),
      const NavigationDestination(
        icon: Icon(Icons.bar_chart_outlined),
        selectedIcon: Icon(Icons.bar_chart),
        label: 'Statistik',
      ),
    ];
    destinations[0] = NavigationDestination(
      icon: Badge(
        isLabelVisible: activeCount > 0,
        label: Text('$activeCount'),
        child: const Icon(Icons.checklist_outlined),
      ),
      selectedIcon: Badge(
        isLabelVisible: activeCount > 0,
        label: Text('$activeCount'),
        child: const Icon(Icons.checklist),
      ),
      label: 'Tugas',
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text(
          'Rencana Kuliah',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                'PLANNER TUGAS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 840) {
              return Row(
                children: [
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) => _navigate(context, index),
                    labelType: NavigationRailLabelType.all,
                    groupAlignment: -0.8,
                    destinations: [
                      NavigationRailDestination(
                        icon: Badge(
                          isLabelVisible: activeCount > 0,
                          label: Text('$activeCount'),
                          child: const Icon(Icons.checklist_outlined),
                        ),
                        selectedIcon: Badge(
                          isLabelVisible: activeCount > 0,
                          label: Text('$activeCount'),
                          child: const Icon(Icons.checklist),
                        ),
                        label: const Text('Tugas'),
                      ),
                      const NavigationRailDestination(
                        icon: Icon(Icons.add_circle_outline),
                        selectedIcon: Icon(Icons.add_circle),
                        label: Text('Tambah'),
                      ),
                      const NavigationRailDestination(
                        icon: Icon(Icons.bar_chart_outlined),
                        selectedIcon: Icon(Icons.bar_chart),
                        label: Text('Statistik'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: child),
                ],
              );
            }

            return Column(
              children: [
                Expanded(child: child),
                NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => _navigate(context, index),
                  destinations: destinations,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
