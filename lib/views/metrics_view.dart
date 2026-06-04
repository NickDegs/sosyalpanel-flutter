import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/platform.dart';
import '../theme/liquid_glass.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: EdgeInsets.fromLTRB(
          16, 8, 16, MediaQuery.paddingOf(context).bottom + 16),
      children: [
        _PlatformSelector(
          selected: _selected,
          onChanged: (p) => setState(() => _selected = p),
        ),
        const SizedBox(height: 12),
        GlassContainer(
          borderRadius: 14,
          padding: const EdgeInsets.all(4),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 7, label: Text('7 gün')),
              ButtonSegment(value: 30, label: Text('30 gün')),
              ButtonSegment(value: 90, label: Text('90 gün')),
            ],
            selected: {_rangeDays},
            onSelectionChanged: (s) => setState(() => _rangeDays = s.first),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return _selected.brandColor.withValues(alpha: 0.3);
                }
                return Colors.transparent;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return isDark ? Colors.white : const Color(0xFF1A1035);
                }
                return isDark ? Colors.white54 : Colors.black45;
              }),
              side: WidgetStateProperty.all(BorderSide.none),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _GlassChartCard(
          title: 'Takipçi Büyümesi',
          platform: _selected,
          child: _FollowerChart(platform: _selected),
        ),
        const SizedBox(height: 12),
        _GlassChartCard(
          title: 'Etkileşim',
          platform: _selected,
          child: _EngagementChart(platform: _selected),
        ),
        const SizedBox(height: 12),
        _GlassChartCard(
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
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final p = SocialPlatform.values[i];
          final isSelected = p == selected;
          return FilterChip(
            label: Text(p.displayName),
            avatar: Icon(p.icon, size: 16),
            selected: isSelected,
            selectedColor: p.brandColor.withValues(alpha: 0.25),
            checkmarkColor: p.brandColor,
            onSelected: (_) => onChanged(p),
          );
        },
      ),
    );
  }
}

class _GlassChartCard extends StatelessWidget {
  final String title;
  final SocialPlatform platform;
  final Widget child;
  const _GlassChartCard(
      {required this.title, required this.platform, required this.child});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      tint: platform.brandColor.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.08 : 0.06),
      borderRadius: 20,
      blur: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: LiquidGlass.textPrimary(context),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _FollowerChart extends StatelessWidget {
  final SocialPlatform platform;
  const _FollowerChart({required this.platform});

  @override
  Widget build(BuildContext context) {
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
              barWidth: 2.5,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    platform.brandColor.withValues(alpha: 0.3),
                    platform.brandColor.withValues(alpha: 0.0),
                  ],
                ),
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
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      platform.brandColor.withValues(alpha: 0.5),
                      platform.brandColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  width: 18,
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
                  style: TextStyle(
                    fontSize: 9,
                    color: LiquidGlass.textSecondary(context),
                  ),
                ),
                interval: 4,
              ),
            ),
            leftTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: [6, 8, 12, 14, 18, 20, 22].asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.value,
              barRods: [
                BarChartRodData(
                  toY: (e.key + 1) * 12.0,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      platform.brandColor.withValues(alpha: 0.4),
                      platform.brandColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  width: 18,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
