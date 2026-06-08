import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/platform.dart';
import '../../providers/account_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/composer_service.dart';
import '../../theme/liquid_glass.dart';
import '../../utils/adaptive.dart';
import '../../utils/animations.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAccounts = ref.watch(accountProvider);
    final topPad = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
    final bottomPad = MediaQuery.paddingOf(context).bottom + 16;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: Text('Ayarlar')),
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(context.hPad, topPad, context.hPad, bottomPad),
        children: [
          // Tracked accounts section
          FadeSlideIn(
            delay: const Duration(milliseconds: 60),
            child: _GlassSection(
              title: 'Takip Edilen Hesaplar',
              children: asyncAccounts.when(
                loading: () => [
                  const ListTile(
                    leading: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    title: Text('Yükleniyor...'),
                  ),
                ],
                error: (e, _) => [ListTile(title: Text('$e'))],
                data: (accounts) => [
                  if (accounts.isEmpty)
                    ListTile(
                      leading: Icon(Icons.info_outline_rounded,
                          color: LiquidGlass.textSecondary(context)),
                      title: Text(
                        'Henüz hesap eklenmedi',
                        style: TextStyle(
                            color: LiquidGlass.textSecondary(context),
                            fontSize: 14),
                      ),
                    )
                  else
                    ...accounts.asMap().entries.map((e) => StaggeredItem(
                          index: e.key,
                          baseDelay: const Duration(milliseconds: 80),
                          stepDelay: const Duration(milliseconds: 30),
                          child: _AccountTile(entry: e.value),
                        )),
                  _AddAccountTile(onAdd: (p, u) async {
                    await ref
                        .read(accountProvider.notifier)
                        .addAccount(platform: p, username: u);
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Tüm platformlar hızlı erişim
          FadeSlideIn(
            delay: const Duration(milliseconds: 140),
            child: _GlassSection(
              title: 'Platformları Aç',
              children: SocialPlatform.values
                  .map((p) => _PlatformOpenTile(platform: p))
                  .toList(),
            ),
          ),

          const SizedBox(height: 12),

          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            child: _GlassSection(
              title: 'Dil / Language',
              children: [_LanguageTile()],
            ),
          ),

          const SizedBox(height: 12),

          FadeSlideIn(
            delay: const Duration(milliseconds: 260),
            child: _GlassSection(
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
          ),
        ],
      ),
    );
  }
}

// MARK: - Section container

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
          child: Material(
            type: MaterialType.transparency,
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

// MARK: - Account tile (with swipe-to-delete)

class _AccountTile extends ConsumerWidget {
  final AccountEntry entry;
  const _AccountTile({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platform = entry.platform;
    return Dismissible(
      key: ValueKey(entry.account.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF87171).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_rounded, color: Color(0xFFF87171)),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Hesabı Sil'),
                content: Text(
                    '@${entry.account.username} (${platform.displayName}) silinsin mi?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('İptal')),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF87171)),
                    child: const Text('Sil'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) =>
          ref.read(accountProvider.notifier).removeAccount(entry.account.id),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: platform.brandColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(platform.icon, color: platform.brandColor, size: 18),
        ),
        title: Text('@${entry.account.username}',
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: Text(
          platform.displayName +
              (entry.latest != null
                  ? '  ·  ${_fmt(entry.latest!.followers)} takipçi'
                  : ''),
          style: TextStyle(
              fontSize: 12, color: LiquidGlass.textSecondary(context)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new_rounded, size: 18),
          onPressed: () => ComposerService.shared.openApp(platform),
          tooltip: '${platform.displayName} uygulamasını aç',
        ),
        dense: true,
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

// MARK: - Add account tile

class _AddAccountTile extends StatelessWidget {
  final Future<void> Function(SocialPlatform, String) onAdd;
  const _AddAccountTile({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.add_rounded,
            color: Theme.of(context).colorScheme.primary, size: 20),
      ),
      title: Text(
        'Hesap Ekle',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onTap: () => _showAddSheet(context),
      dense: true,
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddAccountSheet(onAdd: onAdd),
    );
  }
}

class _AddAccountSheet extends StatefulWidget {
  final Future<void> Function(SocialPlatform, String) onAdd;
  const _AddAccountSheet({required this.onAdd});

  @override
  State<_AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends State<_AddAccountSheet> {
  SocialPlatform _selected = SocialPlatform.instagram;
  final _ctrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_ctrl.text.trim().isEmpty) {
      setState(() => _error = 'Kullanıcı adı boş olamaz');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.onAdd(_selected, _ctrl.text.trim());
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.fromLTRB(
          16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: GlassContainer(
        borderRadius: 24,
        blur: 24,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hesap Ekle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: LiquidGlass.textPrimary(context),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: SocialPlatform.values.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final p = SocialPlatform.values[i];
                  final sel = p == _selected;
                  return ChoiceChip(
                    avatar: Icon(p.icon,
                        size: 14,
                        color: sel
                            ? p.brandColor
                            : (isDark ? Colors.white54 : Colors.black45)),
                    label: Text(p.displayName,
                        style: TextStyle(
                            fontSize: 12, color: sel ? p.brandColor : null)),
                    selected: sel,
                    selectedColor: p.brandColor
                        .withValues(alpha: isDark ? 0.25 : 0.15),
                    onSelected: (_) => setState(() => _selected = p),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                labelText: '${_selected.displayName} kullanıcı adı',
                hintText: 'örn: johndoe',
                prefixText: '@',
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              autofocus: true,
              onSubmitted: (_) => _submit(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!,
                  style: const TextStyle(
                      color: Color(0xFFF87171), fontSize: 13)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Ekle'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// MARK: - Platform open tile

class _PlatformOpenTile extends StatelessWidget {
  final SocialPlatform platform;
  const _PlatformOpenTile({required this.platform});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: platform.brandColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(platform.icon, color: platform.brandColor, size: 18),
      ),
      title: Text(platform.displayName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.open_in_new_rounded, size: 16),
      onTap: () => ComposerService.shared.openApp(platform),
      dense: true,
    );
  }
}

// MARK: - Generic list tile

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

// MARK: - Language tile

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
        style:
            TextStyle(color: LiquidGlass.textSecondary(context), fontSize: 13),
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
                          : const Color(0x28000000)),
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
                            ref.read(localeProvider.notifier).setLocale(null);
                            Navigator.pop(ctx);
                          },
                        ),
                        Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: isDark
                                ? const Color(0x18FFFFFF)
                                : const Color(0x18000000)),
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
