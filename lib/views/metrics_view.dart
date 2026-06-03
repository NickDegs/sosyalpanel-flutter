import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/platform.dart';

class MetricsView extends StatefulWidget {
  const MetricsView({super.key});

  @override
  State<MetricsView> createState() => _MetricsViewState();
}

class _MetricsViewState extends State<MetricsView> {
  SocialPlatform _selected = SocialPlatform.instagram;
  int _rangeDays = 7;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _PlatformSelector(
          selected: _selected,
          onChanged: (p) => setState(() => _selected = p),
        ),
        const SizedBox(height: 12),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 7, label: Text('7 gün')),
            ButtonSegment(value: 30, label: Text('30 gün')),
            ButtonSegment(value: 90, label: Text('90 gün')),
          ],
          selected: {_rangeDays},
          onSelectionChanged: (s) => setState(() => _rangeDays = s.first),
        ),
        const SizedBox(height: 20),
        _ChartCard(
          title: 'Takipçi Büyümesi',
          platform: _selected,
          child: _FollowerChart(platform: _selected),
        ),
        const SizedBox(height: 16),
        _ChartCard(
          title: 'Etkileşim',
          platform: _selected,
          child: _EngagementChart(platform: _selected),
        ),
        const SizedBox(height: 16),
        _ChartCard(
          title: 'En İyi Paylaşım Saati',
          platform: _selected,
          child: _BestTimeChart(platform: _selected),
        ),
      ],
    );
  }
}

class _PlatformSelector extends StatelessWidget {
  final SocialPlatform selected;
  final ValueChanged<SocialPlatform> onChanged;
  const _PlatformSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: SocialPlatform.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final p = SocialPlatform.values[i];
          final isSelected = p == selected;
          return FilterChip(
            label: Text(p.displayName),
            avatar: Icon(p.icon, size: 16),
            selected: isSelected,
            selectedColor: p.brandColor.withValues(alpha: 0.2),
            checkmarkColor: p.brandColor,
            onSelected: (_) => onChanged(p),
          );
        },
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final SocialPlatform platform;
  final Widget child;
  const _ChartCard({required this.title, required this.platform, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _FollowerChart extends StatelessWidget {
  final SocialPlatform platform;
  const _FollowerChart({required this.platform});

  @override
  Widget build(BuildContext context) {
    // Placeholder — gerçek veri MetricSnapshot'tan gelecek
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 100),
                FlSpot(1, 120),
                FlSpot(2, 115),
                FlSpot(3, 145),
                FlSpot(4, 160),
                FlSpot(5, 155),
                FlSpot(6, 180),
              ],
              isCurved: true,
              color: platform.brandColor,
              barWidth: 2,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: platform.brandColor.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EngagementChart extends StatelessWidget {
  final SocialPlatform platform;
  const _EngagementChart({required this.platform});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            7,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: (i + 1) * 15.0,
                  color: platform.brandColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BestTimeChart extends StatelessWidget {
  final SocialPlatform platform;
  const _BestTimeChart({required this.platform});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}:00',
                  style: const TextStyle(fontSize: 9),
                ),
                interval: 4,
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: [6, 8, 12, 14, 18, 20, 22].asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.value,
              barRods: [
                BarChartRodData(
                  toY: (e.key + 1) * 12.0,
                  color: platform.brandColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
