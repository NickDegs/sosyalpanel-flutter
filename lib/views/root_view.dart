import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_view.dart';
import 'analytics_view.dart';
import 'composer_view.dart';
import 'actions_view.dart';
import 'settings/settings_view.dart';

class RootView extends ConsumerStatefulWidget {
  const RootView({super.key});

  @override
  ConsumerState<RootView> createState() => _RootViewState();
}

class _RootViewState extends ConsumerState<RootView> {
  int _selectedIndex = 0;

  static const _tabs = [
    NavigationDestination(icon: Icon(Icons.grid_view), label: 'Genel'),
    NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Analiz'),
    NavigationDestination(icon: Icon(Icons.edit_note), label: 'Paylaş'),
    NavigationDestination(icon: Icon(Icons.checklist), label: 'Aksiyon'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Ayarlar'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          DashboardView(),
          AnalyticsView(),
          ComposerView(),
          ActionsView(),
          SettingsView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: _tabs,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}
