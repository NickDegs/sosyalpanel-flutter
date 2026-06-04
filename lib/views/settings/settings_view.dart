import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/platform.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/auth_service.dart';
import '../../theme/liquid_glass.dart';
import '../auth/bluesky_auth_sheet.dart';
import '../auth/simple_auth_sheet.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = ref.watch(connectedPlatformsProvider);
    final topPad = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
    final bottomPad = MediaQuery.paddingOf(context).bottom + 16;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: Text('Ayarlar')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, topPad, 16, bottomPad),
        children: [
          _GlassSection(
            title: 'Bağlı Hesaplar',
            children: SocialPlatform.values
                .map((p) => _PlatformTile(
                      platform: p,
                      isConnected: connected.contains(p),
                      onConnect: () => _connect(context, ref, p),
                      onDisconnect: () =>
                          ref.read(authProvider.notifier).disconnect(p),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          _GlassSection(
            title: 'Dil / Language',
            children: [_LanguageTile()],
          ),
          const SizedBox(height: 12),
          _GlassSection(
            title: 'Uygulama',
            children: [
              _GlassListTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Gizlilik Politikası',
                trailing: const Icon(Icons.open_in_new, size: 14),
                onTap: () {},
              ),
              _GlassListTile(
                icon: Icons.description_outlined,
                title: 'Kullanım Koşulları',
                trailing: const Icon(Icons.open_in_new, size: 14),
                onTap: () {},
              ),
              _GlassListTile(
                icon: Icons.info_outline_rounded,
                title: 'Sürüm',
                trailing: Text(
                  '1.0.0',
                  style: TextStyle(
                    color: LiquidGlass.textSecondary(context),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _connect(BuildContext context, WidgetRef ref, SocialPlatform platform) async {
    switch (platform.authMode) {
      case AuthMode.appPassword:
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlueskyAuthSheet(onSuccess: () {
            ref.read(authProvider.notifier).reload();
            Navigator.pop(context);
          }),
        );
      case AuthMode.apiKey:
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => SimpleAuthSheet(
            platform: platform,
            label: 'API Key',
            onSuccess: (key) async {
              await AuthService.shared.saveApiKey(platform, key);
              ref.read(authProvider.notifier).reload();
              if (context.mounted) Navigator.pop(context);
            },
          ),
        );
      case AuthMode.botToken:
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => SimpleAuthSheet(
            platform: platform,
            label: 'Bot Token',
            onSuccess: (token) async {
              await AuthService.shared.saveApiKey(platform, token);
              ref.read(authProvider.notifier).reload();
              if (context.mounted) Navigator.pop(context);
            },
          ),
        );
      case AuthMode.webhook:
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => SimpleAuthSheet(
            platform: platform,
            label: 'Webhook URL',
            onSuccess: (url) async {
              await AuthService.shared.saveApiKey(platform, url);
              ref.read(authProvider.notifier).reload();
              if (context.mounted) Navigator.pop(context);
            },
          ),
        );
      case AuthMode.oauth2PerInstance:
        final host = await _askMastodonInstance(context);
        if (host == null || !context.mounted) return;
        try {
          await AuthService.shared.connect(platform, instanceHost: host);
          ref.read(authProvider.notifier).reload();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('$e')));
          }
        }
      case AuthMode.oauth2:
        try {
          await AuthService.shared.connect(platform);
          ref.read(authProvider.notifier).reload();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('$e')));
          }
        }
    }
  }

  Future<String?> _askMastodonInstance(BuildContext context) {
    final ctrl = TextEditingController(text: 'mastodon.social');
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mastodon Sunucusu'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'mastodon.social'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Bağlan'),
          ),
        ],
      ),
    );
  }
}

class _GlassSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _GlassSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: LiquidGlass.textSecondary(context),
              letterSpacing: 0.8,
            ),
          ),
        ),
        GlassContainer(
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _GlassListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _GlassListTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: trailing,
      onTap: onTap,
      dense: true,
    );
  }
}

class _LanguageTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final currentCode = locale?.languageCode;
    final currentName = currentCode != null
        ? languageNames[currentCode] ?? currentCode
        : 'Sistem dili';

    return ListTile(
      leading: const Icon(Icons.language_rounded, size: 20),
      title: const Text('Uygulama Dili', style: TextStyle(fontSize: 15)),
      trailing: Text(
        currentName,
        style: TextStyle(
          color: LiquidGlass.textSecondary(context),
          fontSize: 13,
        ),
      ),
      dense: true,
      onTap: () => _showPicker(context, ref, currentCode),
    );
  }

  void _showPicker(BuildContext context, WidgetRef ref, String? current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          margin: EdgeInsets.fromLTRB(
              16, 0, 16, MediaQuery.paddingOf(ctx).bottom + 16),
          child: GlassContainer(
            borderRadius: 24,
            blur: 24,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Text(
                      'Dil Seç',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: LiquidGlass.textPrimary(ctx),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: isDark
                        ? const Color(0x28FFFFFF)
                        : const Color(0x28000000),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 360),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.phone_android_rounded),
                          title: const Text('Sistem dili'),
                          trailing: current == null
                              ? Icon(Icons.check_rounded,
                                  color: Theme.of(ctx).colorScheme.primary)
                              : null,
                          onTap: () {
                            ref
                                .read(localeProvider.notifier)
                                .setLocale(null);
                            Navigator.pop(ctx);
                          },
                        ),
                        Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: isDark
                              ? const Color(0x18FFFFFF)
                              : const Color(0x18000000),
                        ),
                        ...languageNames.entries.map((e) => ListTile(
                              title: Text(
                                  '${e.value}  —  ${appNameByLocale[e.key] ?? ''}'),
                              trailing: current == e.key
                                  ? Icon(Icons.check_rounded,
                                      color:
                                          Theme.of(ctx).colorScheme.primary)
                                  : null,
                              onTap: () {
                                ref
                                    .read(localeProvider.notifier)
                                    .setLocale(e.key);
                                Navigator.pop(ctx);
                              },
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PlatformTile extends StatelessWidget {
  final SocialPlatform platform;
  final bool isConnected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const _PlatformTile({
    required this.platform,
    required this.isConnected,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: platform.brandColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: platform.brandColor.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Icon(platform.icon, color: platform.brandColor, size: 18),
      ),
      title: Text(
        platform.displayName,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        isConnected ? 'Bağlı' : 'Bağlı değil',
        style: TextStyle(
          color: isConnected
              ? const Color(0xFF34D399)
              : LiquidGlass.textSecondary(context),
          fontSize: 12,
        ),
      ),
      trailing: isConnected
          ? IconButton(
              icon: const Icon(Icons.link_off_rounded,
                  color: Color(0xFFF87171), size: 20),
              onPressed: onDisconnect,
            )
          : FilledButton.tonal(
              onPressed: onConnect,
              style: FilledButton.styleFrom(
                backgroundColor:
                    platform.brandColor.withValues(alpha: 0.15),
                foregroundColor: platform.brandColor,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                minimumSize: const Size(0, 32),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Bağla', style: TextStyle(fontSize: 13)),
            ),
      dense: true,
    );
  }
}
