import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analiz'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Metrikler'),
            Tab(text: 'Takipçiler'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          MetricsView(),
          FollowerTrackingView(),
        ],
      ),
    );
  }
}
