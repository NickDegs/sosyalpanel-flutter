import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kGlassDark = Color(0x1AFFFFFF);
const _kGlassLight = Color(0x55FFFFFF);
const _kBorderDark = Color(0x28FFFFFF);
const _kBorderLight = Color(0x50FFFFFF);

class LiquidGlass {
  static const colorSeed = Color(0xFF8B5CF6);

  static const darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D0B1E), Color(0xFF1A0D3A), Color(0xFF0E1A3E)],
    stops: [0.0, 0.5, 1.0],
  );

  static const lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEDE9FE), Color(0xFFDDD6FE), Color(0xFFE0E7FF)],
    stops: [0.0, 0.5, 1.0],
  );

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1035);

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white60 : const Color(0xFF6B5EA7);
}

/// Full-screen gradient background — wraps the root body.
class GlassBackground extends StatelessWidget {
  final Widget child;
  const GlassBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? LiquidGlass.darkGradient : LiquidGlass.lightGradient,
      ),
      child: child,
    );
  }
}

/// Frosted glass container — blurs background and adds semi-transparent surface.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? tint;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blur = 16,
    this.padding,
    this.margin,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = tint ?? (isDark ? _kGlassDark : _kGlassLight);
    final border = isDark ? _kBorderDark : _kBorderLight;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: border, width: 0.5),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Glass AppBar — use as the `appBar` parameter of a Scaffold.
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double blur;
  final bool automaticallyImplyLeading;

  const GlassAppBar({
    super.key,
    this.title,
    this.actions,
    this.bottom,
    this.blur = 20,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? Colors.white : const Color(0xFF1A1035);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AppBar(
          title: title,
          actions: actions,
          bottom: bottom,
          automaticallyImplyLeading: automaticallyImplyLeading,
          backgroundColor: isDark ? const Color(0x28000000) : const Color(0x55FFFFFF),
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: fg,
          iconTheme: IconThemeData(color: fg),
          titleTextStyle: GoogleFonts.nunito(
            color: fg,
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

/// Glass bottom navigation bar.
class GlassNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const GlassNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
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
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0x33000000) : const Color(0x66FFFFFF),
            border: Border(
              top: BorderSide(
                color: isDark ? const Color(0x28FFFFFF) : const Color(0x44FFFFFF),
                width: 0.5,
              ),
            ),
          ),
          padding: EdgeInsets.only(bottom: bottomPad, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final (activeIcon, icon, label) = _items[i];
              final selected = i == selectedIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: selected
                      ? BoxDecoration(
                          color: primary.withValues(alpha: isDark ? 0.25 : 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: primary.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? activeIcon : icon,
                        color: selected
                            ? primary
                            : (isDark ? Colors.white38 : Colors.black38),
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w500,
                          color: selected
                              ? primary
                              : (isDark ? Colors.white38 : Colors.black38),
                          letterSpacing: selected ? 0.2 : 0,
                        ),
                        child: Text(label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
