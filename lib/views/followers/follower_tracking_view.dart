import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/platform.dart';
import '../../models/follower_record.dart';
import '../../models/database.dart';
import '../../services/follower_tracking_service.dart';
import '../../services/keychain_service.dart';

enum FollowerSegment { newFollowers, unfollowers, notFollowingBack, notFollowedBack }

class FollowerTrackingView extends ConsumerStatefulWidget {
  const FollowerTrackingView({super.key});

  @override
  ConsumerState<FollowerTrackingView> createState() => _FollowerTrackingViewState();
}

class _FollowerTrackingViewState extends ConsumerState<FollowerTrackingView> {
  SocialPlatform _platform = FollowerTrackingService.listSupportedPlatforms.first;
  FollowerSegment _segment = FollowerSegment.notFollowingBack;
  bool _isRefreshing = false;
  FollowerDiff _diff = FollowerDiff.empty;
  DateTime? _lastRefresh;

  @override
  void initState() {
    super.initState();
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    final rows = await (database.select(database.followerSnapshots)
          ..where((t) => t.platformRaw.equals(_platform.name))
          ..orderBy([(t) => OrderingTerm.desc(t.capturedAt)])
          ..limit(2))
        .get();

    if (rows.isEmpty) return;

    final current = rows[0];
    final prev = rows.length >= 2 ? rows[1] : null;

    final currentFollowers = FollowerRecord.listFromJson(current.followersJson);
    final currentFollowing = FollowerRecord.listFromJson(current.followingJson);
    final previousFollowers = prev != null ? FollowerRecord.listFromJson(prev.followersJson) : null;

    setState(() {
      _diff = FollowerTrackingService.shared.computeDiff(
        currentFollowers: currentFollowers,
        currentFollowing: currentFollowing,
        previousFollowers: previousFollowers,
      );
      _lastRefresh = current.capturedAt;
    });
  }

  Future<void> _refresh() async {
    final hasToken = await KeychainService.shared.hasToken(_platform);
    if (!hasToken) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_platform.displayName} bağlı değil. Ayarlardan bağlayın.')),
        );
      }
      return;
    }

    setState(() => _isRefreshing = true);
    try {
      final lists = await FollowerTrackingService.shared.fetchLists(_platform);

      await database.into(database.followerSnapshots).insert(
            FollowerSnapshotsCompanion.insert(
              platformRaw: _platform.name,
              followersJson: Value(FollowerRecord.listToJson(lists.followers)),
              followingJson: Value(FollowerRecord.listToJson(lists.following)),
            ),
          );

      await _loadFromDb();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  List<FollowerRecord> get _displayedRecords => switch (_segment) {
        FollowerSegment.newFollowers => _diff.newFollowers,
        FollowerSegment.unfollowers => _diff.unfollowers,
        FollowerSegment.notFollowingBack => _diff.notFollowingBack,
        FollowerSegment.notFollowedBack => _diff.notFollowedBack,
      };

  String _segmentLabel(FollowerSegment s) {
    final count = switch (s) {
      FollowerSegment.newFollowers => _diff.newFollowers.length,
      FollowerSegment.unfollowers => _diff.unfollowers.length,
      FollowerSegment.notFollowingBack => _diff.notFollowingBack.length,
      FollowerSegment.notFollowedBack => _diff.notFollowedBack.length,
    };
    final base = switch (s) {
      FollowerSegment.newFollowers => 'Yeni',
      FollowerSegment.unfollowers => 'Bıraktı',
      FollowerSegment.notFollowingBack => 'Geri Takip Yok',
      FollowerSegment.notFollowedBack => 'Ben Takip Etmiyorum',
    };
    return count > 0 ? '$base ($count)' : base;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Platform selector
        SizedBox(
          height: 52,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: FollowerTrackingService.listSupportedPlatforms.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final p = FollowerTrackingService.listSupportedPlatforms[i];
              final sel = p == _platform;
              return FilterChip(
                avatar: Icon(p.icon, size: 16, color: sel ? p.brandColor : null),
                label: Text(p.displayName),
                selected: sel,
                selectedColor: p.brandColor.withValues(alpha: 0.15),
                checkmarkColor: p.brandColor,
                onSelected: (_) {
                  setState(() {
                    _platform = p;
                    _segment = FollowerSegment.notFollowingBack;
                    _diff = FollowerDiff.empty;
                  });
                  _loadFromDb();
                },
              );
            },
          ),
        ),

        // Summary row
        if (_lastRefresh != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _StatChip(label: 'Takipçi', value: _diff.totalFollowers, color: Colors.blue),
                const SizedBox(width: 8),
                _StatChip(label: 'Takip', value: _diff.totalFollowing, color: Colors.purple),
                const Spacer(),
                if (_diff.newFollowers.isNotEmpty)
                  _StatChip(label: '+${_diff.newFollowers.length}', color: Colors.green),
                const SizedBox(width: 6),
                if (_diff.unfollowers.isNotEmpty)
                  _StatChip(label: '-${_diff.unfollowers.length}', color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  _formatRelative(_lastRefresh!),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

        // Segment buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: FollowerSegment.values.map((s) {
                final sel = s == _segment;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_segmentLabel(s), style: const TextStyle(fontSize: 12)),
                    selected: sel,
                    selectedColor: _platform.brandColor.withValues(alpha: 0.15),
                    checkmarkColor: _platform.brandColor,
                    onSelected: (_) => setState(() => _segment = s),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const Divider(height: 1),

        // List or empty/no-data state
        Expanded(
          child: _lastRefresh == null
              ? _NoDataView(platform: _platform, onRefresh: _refresh, isLoading: _isRefreshing)
              : _displayedRecords.isEmpty
                  ? _EmptySegmentView(segment: _segment, platform: _platform)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _displayedRecords.length,
                      itemBuilder: (context, i) =>
                          _FollowerRow(record: _displayedRecords[i], platform: _platform),
                    ),
        ),
      ],
    );
  }

  String _formatRelative(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'şimdi';
    if (diff.inHours < 1) return '${diff.inMinutes}dk önce';
    if (diff.inDays < 1) return '${diff.inHours}sa önce';
    return '${diff.inDays}g önce';
  }
}

// MARK: - Sub-widgets

class _StatChip extends StatelessWidget {
  final String label;
  final int? value;
  final Color color;
  const _StatChip({required this.label, this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final text = value != null ? '$label $value' : label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _NoDataView extends StatelessWidget {
  final SocialPlatform platform;
  final VoidCallback onRefresh;
  final bool isLoading;
  const _NoDataView({required this.platform, required this.onRefresh, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 64, color: platform.brandColor.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text('Henüz veri yok', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'İlk snapshot\'ı almak için güncelle butonuna dokun.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: isLoading ? null : onRefresh,
            icon: isLoading
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.refresh),
            label: Text(isLoading ? 'Yükleniyor...' : 'Şimdi Güncelle'),
          ),
        ],
      ),
    );
  }
}

class _EmptySegmentView extends StatelessWidget {
  final FollowerSegment segment;
  final SocialPlatform platform;
  const _EmptySegmentView({required this.segment, required this.platform});

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = switch (segment) {
      FollowerSegment.newFollowers => (Icons.person_add_outlined, 'Yeni takipçi yok', 'Son güncellemeden beri yeni takipçi gelmedi.'),
      FollowerSegment.unfollowers => (Icons.person_remove_outlined, 'Kimse bırakmadı', 'Son güncellemeden beri kimse seni takibi bırakmadı.'),
      FollowerSegment.notFollowingBack => (Icons.check_circle_outline, 'Herkes geri takip ediyor', 'Takip ettiğin herkes seni de takip ediyor.'),
      FollowerSegment.notFollowedBack => (Icons.done_all, 'Herkesi takip ediyorsun', 'Seni takip eden herkesi sen de takip ediyorsun.'),
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 52, color: platform.brandColor.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class _FollowerRow extends StatelessWidget {
  final FollowerRecord record;
  final SocialPlatform platform;
  const _FollowerRow({required this.record, required this.platform});

  String get _initials {
    final source = record.displayName?.isNotEmpty == true ? record.displayName! : record.handle;
    final words = source.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return source.substring(0, source.length.clamp(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: platform.brandColor.withValues(alpha: 0.15),
        child: Text(
          _initials,
          style: TextStyle(color: platform.brandColor, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        record.displayName?.isNotEmpty == true ? record.displayName! : record.handle,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: record.displayName?.isNotEmpty == true
          ? Text(record.handle, style: const TextStyle(fontSize: 12))
          : null,
    );
  }
}
