import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/platform.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/liquid_glass.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final connected = ref.watch(connectedPlatformsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text(ref.watch(localeProvider.notifier).appName(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(authProvider.notifier).reload(),
          ),
        ],
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Hata: $e',
              style: TextStyle(color: LiquidGlass.textSecondary(context))),
        ),
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
    final topPad =
        MediaQuery.paddingOf(context).top + kToolbarHeight;
    return Padding(
      padding: EdgeInsets.only(top: topPad),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlassContainer(
              borderRadius: 28,
              padding: const EdgeInsets.all(28),
              child: Icon(
                Icons.share_rounded,
                size: 52,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Henüz hesap bağlanmadı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: LiquidGlass.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ayarlar sekmesinden bir platform bağlayın.',
              style: TextStyle(
                color: LiquidGlass.textSecondary(context),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountGrid extends StatelessWidget {
  final List<SocialPlatform> connected;
  const _AccountGrid({required this.connected});

  @override
  Widget build(BuildContext context) {
    final topPad =
        MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
    final bottomPad = MediaQuery.paddingOf(context).bottom + 16;

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16, topPad, 16, bottomPad),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassContainer(
      tint: platform.brandColor.withValues(alpha: isDark ? 0.18 : 0.12),
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
                  color: platform.brandColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(platform.icon, color: platform.brandColor, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  platform.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: LiquidGlass.textPrimary(context),
                    fontSize: 13,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '—',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: LiquidGlass.textPrimary(context),
            ),
          ),
          Text(
            'takipçi',
            style: TextStyle(
              fontSize: 11,
              color: LiquidGlass.textSecondary(context),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
