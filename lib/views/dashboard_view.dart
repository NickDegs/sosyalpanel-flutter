import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/platform.dart';
import '../providers/auth_provider.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final connected = ref.watch(connectedPlatformsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SosyalPanel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(authProvider.notifier).reload(),
          ),
        ],
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (state) => state.connected.isEmpty
            ? _EmptyState()
            : _AccountGrid(connected: connected.toList()),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.share, size: 64, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text('Henüz hesap bağlanmadı', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Ayarlar sekmesinden bir platform bağlayın.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _AccountGrid extends StatelessWidget {
  final List<SocialPlatform> connected;
  const _AccountGrid({required this.connected});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: connected.length,
      itemBuilder: (context, i) => _PlatformCard(platform: connected[i]),
    );
  }
}

class _PlatformCard extends StatelessWidget {
  final SocialPlatform platform;
  const _PlatformCard({required this.platform});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: platform.brandColor.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(platform.icon, color: platform.brandColor, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    platform.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: platform.brandColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Text('—', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('takipçi', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
