import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/platform.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/auth_service.dart';
import '../auth/bluesky_auth_sheet.dart';
import '../auth/simple_auth_sheet.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = ref.watch(connectedPlatformsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          const _SectionHeader('Bağlı Hesaplar'),
          ...SocialPlatform.values.map((p) => _PlatformTile(
                platform: p,
                isConnected: connected.contains(p),
                onConnect: () => _connect(context, ref, p),
                onDisconnect: () => ref.read(authProvider.notifier).disconnect(p),
              )),
          const Divider(),
          const _SectionHeader('Dil / Language'),
          _LanguageTile(),
          const Divider(),
          const _SectionHeader('Uygulama'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Gizlilik Politikası'),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Kullanım Koşulları'),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sürüm'),
            trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
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
          builder: (_) => BlueskyAuthSheet(onSuccess: () {
            ref.read(authProvider.notifier).reload();
            Navigator.pop(context);
          }),
        );
      case AuthMode.apiKey:
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
          }
        }
      case AuthMode.oauth2:
        try {
          await AuthService.shared.connect(platform);
          ref.read(authProvider.notifier).reload();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Bağlan'),
          ),
        ],
      ),
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
      leading: const Icon(Icons.language),
      title: const Text('Uygulama Dili'),
      trailing: Text(currentName, style: const TextStyle(color: Colors.grey)),
      onTap: () => _showPicker(context, ref, currentCode),
    );
  }

  void _showPicker(BuildContext context, WidgetRef ref, String? current) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Dil Seç', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: const Text('Sistem dili'),
              trailing: current == null ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(null);
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1),
            ...languageNames.entries.map((e) => ListTile(
              title: Text('${e.value}  —  ${appNameByLocale[e.key] ?? ''}'),
              trailing: current == e.key ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(e.key);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
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
      leading: CircleAvatar(
        backgroundColor: platform.brandColor.withValues(alpha: 0.12),
        child: Icon(platform.icon, color: platform.brandColor, size: 20),
      ),
      title: Text(platform.displayName),
      subtitle: Text(isConnected ? 'Bağlı' : 'Bağlı değil',
          style: TextStyle(color: isConnected ? Colors.green : Colors.grey, fontSize: 12)),
      trailing: isConnected
          ? IconButton(
              icon: const Icon(Icons.link_off, color: Colors.red, size: 20),
              onPressed: onDisconnect,
            )
          : FilledButton.tonal(
              onPressed: onConnect,
              style: FilledButton.styleFrom(
                backgroundColor: platform.brandColor.withValues(alpha: 0.1),
                foregroundColor: platform.brandColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(0, 32),
              ),
              child: const Text('Bağla', style: TextStyle(fontSize: 13)),
            ),
    );
  }
}
