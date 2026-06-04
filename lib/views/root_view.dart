import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/liquid_glass.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: GlassBackground(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            DashboardView(),
            AnalyticsView(),
            ComposerView(),
            ActionsView(),
            SettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: GlassNavBar(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}
