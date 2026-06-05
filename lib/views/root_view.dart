import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/liquid_glass.dart';
import '../utils/adaptive.dart';
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

  static const _pages = [
    DashboardView(),
    AnalyticsView(),
    ComposerView(),
    ActionsView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: context.isTablet
          ? _TabletScaffold(
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
              child: _pages[_selectedIndex],
            )
          : _PhoneScaffold(
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
    );
  }
}

// ─── Phone layout ─────────────────────────────────────────────────────────────

class _PhoneScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _PhoneScaffold({required this.selectedIndex, required this.onTap});

  static const _pages = [
    DashboardView(),
    AnalyticsView(),
    ComposerView(),
    ActionsView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: GlassNavBar(
        selectedIndex: selectedIndex,
        onTap: onTap,
      ),
    );
  }
}

// ─── Tablet layout ────────────────────────────────────────────────────────────

class _TabletScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Widget child;
  const _TabletScaffold({
    required this.selectedIndex,
    required this.onTap,
    required this.child,
  });

  static const _items = [
    (Icons.grid_view_rounded, Icons.grid_view_outlined, 'Genel'),
    (Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Analiz'),
    (Icons.edit_rounded, Icons.edit_outlined, 'Paylaş'),
    (Icons.checklist_rounded, Icons.checklist_outlined, 'Aksiyon'),
    (Icons.settings_rounded, Icons.settings_outlined, 'Ayarlar'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final extended = context.isLargeTablet;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          // Glass sidebar rail
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                width: extended ? 200 : 72,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0x28000000) : const Color(0x55FFFFFF),
                  border: Border(
                    right: BorderSide(
                      color: isDark ? const Color(0x28FFFFFF) : const Color(0x44FFFFFF),
                      width: 0.5,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(top: topPad + 16, bottom: bottomPad + 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (extended) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Text(
                          'Social Panel',
                          style: GoogleFonts.nunito(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: LiquidGlass.textPrimary(context),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                    ],
                    ...List.generate(_items.length, (i) {
                      final (activeIcon, icon, label) = _items[i];
                      final selected = i == selectedIndex;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: GestureDetector(
                          onTap: () => onTap(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: extended ? 12 : 8,
                              vertical: 10,
                            ),
                            decoration: selected
                                ? BoxDecoration(
                                    color: primary.withValues(
                                        alpha: isDark ? 0.25 : 0.15),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: primary.withValues(alpha: 0.3),
                                      width: 0.5,
                                    ),
                                  )
                                : null,
                            child: extended
                                ? Row(
                                    children: [
                                      Icon(
                                        selected ? activeIcon : icon,
                                        color: selected
                                            ? primary
                                            : (isDark ? Colors.white38 : Colors.black38),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        label,
                                        style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          fontWeight: selected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: selected
                                              ? primary
                                              : (isDark ? Colors.white54 : Colors.black54),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Icon(
                                      selected ? activeIcon : icon,
                                      color: selected
                                          ? primary
                                          : (isDark ? Colors.white38 : Colors.black38),
                                      size: 22,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Expanded(child: child),
        ],
      ),
    );
  }
}
