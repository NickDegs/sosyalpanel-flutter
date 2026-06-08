import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/database.dart';
import '../models/platform.dart';
import '../providers/account_provider.dart';
import '../theme/liquid_glass.dart';
import '../utils/adaptive.dart';
import '../utils/animations.dart';

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
          tabs: const [Tab(text: 'Grafikler'), Tab(text: 'Güncelle')],
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
            FadeSlideIn(child: _ChartsTab()),
            FadeSlideIn(child: _UpdateTab()),
          ],
        ),
      ),
    );
  }
}

// MARK: - Charts Tab

class _ChartsTab extends ConsumerStatefulWidget {
  const _ChartsTab();

  @override
  ConsumerState<_ChartsTab> createState() => _ChartsTabState();
}

class _ChartsTabState extends ConsumerState<_ChartsTab> {
  AccountEntry? _selected;

  @override
  Widget build(BuildContext context) {
    final asyncAccounts = ref.watch(accountProvider);

    return asyncAccounts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (accounts) {
        if (accounts.isEmpty) {
          return Center(
            child: Text(
              'Henüz hesap yok.\nDashboard\'dan hesap ekleyin.',
              textAlign: TextAlign.center,
              style: TextStyle(color: LiquidGlass.textSecondary(context)),
            ),
          );
        }

        _selected ??= accounts.first;
        final current = accounts.firstWhere(
          (a) => a.account.id == _selected!.account.id,
          orElse: () => accounts.first,
        );

        return ListView(
          padding: EdgeInsets.fromLTRB(
              context.hPad, 8, context.hPad,
              MediaQuery.paddingOf(context).bottom + 16),
          children: [
            // Account selector
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: accounts.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final a = accounts[i];
                  final sel = a.account.id == current.account.id;
                  return FilterChip(
                    avatar: Icon(a.platform.icon, size: 14),
                    label: Text('@${a.account.username}'),
                    selected: sel,
                    selectedColor:
                        a.platform.brandColor.withValues(alpha: 0.2),
                    checkmarkColor: a.platform.brandColor,
                    onSelected: (_) => setState(() => _selected = a),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _FollowerChartCard(entry: current),
          ],
        );
      },
    );
  }
}

class _FollowerChartCard extends StatefulWidget {
  final AccountEntry entry;
  const _FollowerChartCard({required this.entry});

  @override
  State<_FollowerChartCard> createState() => _FollowerChartCardState();
}

class _FollowerChartCardState extends State<_FollowerChartCard> {
  List<MetricSnapshot> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(_FollowerChartCard old) {
    super.didUpdateWidget(old);
    if (old.entry.account.id != widget.entry.account.id) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await database.accountDao
        .snapshotHistory(widget.entry.account.id, limit: 30);
    setState(() {
      _history = rows.reversed.toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final platform = widget.entry.platform;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      tint: platform.brandColor
          .withValues(alpha: isDark ? 0.08 : 0.06),
      borderRadius: 20,
      blur: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Takipçi Geçmişi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: LiquidGlass.textPrimary(context),
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              if (widget.entry.latest != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: platform.brandColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _fmt(widget.entry.latest!.followers),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: platform.brandColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_loading)
            const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()))
          else if (_history.length < 2)
            SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  'En az 2 veri noktası gerekli.\nGüncelle sekmesinden veri girin.',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: LiquidGlass.textSecondary(context)),
                ),
              ),
            )
          else
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i >= _history.length) return const SizedBox();
                          if (i != 0 && i != _history.length - 1 && i != _history.length ~/ 2) {
                            return const SizedBox();
                          }
                          final dt = _history[i].capturedAt;
                          return Text(
                            '${dt.day}/${dt.month}',
                            style: TextStyle(
                              fontSize: 9,
                              color: LiquidGlass.textSecondary(context),
                            ),
                          );
                        },
                        reservedSize: 20,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _history.asMap().entries.map((e) {
                        return FlSpot(
                            e.key.toDouble(), e.value.followers.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: platform.brandColor,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, _, __, ___) =>
                            FlDotCirclePainter(
                          radius: 3,
                          color: platform.brandColor,
                          strokeColor: Colors.transparent,
                        ),
                      ),
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
            ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

// MARK: - Update Tab

class _UpdateTab extends ConsumerWidget {
  const _UpdateTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAccounts = ref.watch(accountProvider);

    return asyncAccounts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (accounts) {
        if (accounts.isEmpty) {
          return Center(
            child: Text(
              'Henüz hesap yok.',
              style: TextStyle(color: LiquidGlass.textSecondary(context)),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(
              context.hPad, 8, context.hPad,
              MediaQuery.paddingOf(context).bottom + 16),
          itemCount: accounts.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, i) => StaggeredItem(
            index: i,
            child: _MetricEntryCard(entry: accounts[i], ref: ref),
          ),
        );
      },
    );
  }
}

class _MetricEntryCard extends StatefulWidget {
  final AccountEntry entry;
  final WidgetRef ref;
  const _MetricEntryCard({required this.entry, required this.ref});

  @override
  State<_MetricEntryCard> createState() => _MetricEntryCardState();
}

class _MetricEntryCardState extends State<_MetricEntryCard> {
  final _followerCtrl = TextEditingController();
  final _followingCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _followerCtrl.dispose();
    _followingCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final f = int.tryParse(_followerCtrl.text.replaceAll(',', '').replaceAll('.', ''));
    if (f == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Geçerli bir sayı girin')));
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.ref.read(accountProvider.notifier).saveMetric(
            accountId: widget.entry.account.id,
            followers: f,
            following: int.tryParse(
                _followingCtrl.text.replaceAll(',', '').replaceAll('.', '')),
          );
      _followerCtrl.clear();
      _followingCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.entry.platform.displayName} güncellendi'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = widget.entry.platform;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final latest = widget.entry.latest;

    return GlassContainer(
      tint: platform.brandColor.withValues(alpha: isDark ? 0.12 : 0.08),
      borderRadius: 20,
      blur: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: platform.brandColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(platform.icon, color: platform.brandColor, size: 16),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platform.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: LiquidGlass.textPrimary(context),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '@${widget.entry.account.username}',
                    style: TextStyle(
                      fontSize: 11,
                      color: LiquidGlass.textSecondary(context),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (latest != null)
                Text(
                  _fmt(latest.followers),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: platform.brandColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _followerCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Takipçi',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _followingCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Takip (isteğe bağlı)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: platform.brandColor,
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Kaydet', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}
