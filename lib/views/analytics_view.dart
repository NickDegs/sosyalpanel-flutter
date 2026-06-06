import 'package:flutter/material.dart';
import '../theme/liquid_glass.dart';
import '../utils/animations.dart';
import 'followers/follower_tracking_view.dart';
import 'metrics_view.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: const Text('Analiz'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Metrikler'),
            Tab(text: 'Takipçiler'),
          ],
          labelColor: isDark ? Colors.white : const Color(0xFF1A1035),
          unselectedLabelColor: isDark ? Colors.white38 : Colors.black38,
          indicatorColor: primary,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          splashBorderRadius: BorderRadius.circular(8),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + kToolbarHeight + 46,
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
        child: TabBarView(
          controller: _tab,
          children: const [
            FadeSlideIn(child: MetricsView()),
            FadeSlideIn(child: FollowerTrackingView()),
          ],
        ),
      ),
    );
  }
}
