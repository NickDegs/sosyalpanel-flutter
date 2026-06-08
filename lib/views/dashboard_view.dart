import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/platform.dart';
import '../providers/account_provider.dart';
import '../providers/locale_provider.dart';
import '../services/composer_service.dart';
import '../theme/liquid_glass.dart';
import '../utils/adaptive.dart';
import '../utils/animations.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAccounts = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text(ref.watch(localeProvider.notifier).appName(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(accountProvider.notifier).reload(),
          ),
        ],
      ),
      body: asyncAccounts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Hata: $e',
              style: TextStyle(color: LiquidGlass.textSecondary(context))),
        ),
        data: (accounts) => accounts.isEmpty
            ? const _EmptyState()
            : _AccountGrid(accounts: accounts),
      ),
      floatingActionButton: _AddAccountFab(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top + kToolbarHeight;
    return Padding(
      padding: EdgeInsets.only(top: topPad),
      child: Center(
        child: FadeSlideIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatLoop(
                child: GlassContainer(
                  borderRadius: 28,
                  padding: const EdgeInsets.all(28),
                  child: Icon(
                    Icons.add_link_rounded,
                    size: 52,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Henüz hesap eklenmedi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: LiquidGlass.textPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sağ alttaki + butonuna dokun.',
                style: TextStyle(
                  color: LiquidGlass.textSecondary(context),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountGrid extends StatelessWidget {
  final List<AccountEntry> accounts;
  const _AccountGrid({required this.accounts});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
    final bottomPad = MediaQuery.paddingOf(context).bottom + 80;
    final cols = context.gridColumns;

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(context.hPad, topPad, context.hPad, bottomPad),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: context.cardAspectRatio,
      ),
      itemCount: accounts.length,
      itemBuilder: (context, i) => StaggeredItem(
        index: i,
        child: PressScale(
          onTap: () => ComposerService.shared.openApp(accounts[i].platform),
          child: _AccountCard(entry: accounts[i]),
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final AccountEntry entry;
  const _AccountCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final platform = entry.platform;
    final followers = entry.latest?.followers;

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
          const SizedBox(height: 6),
          Text(
            '@${entry.account.username}',
            style: TextStyle(
              fontSize: 11,
              color: LiquidGlass.textSecondary(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            followers != null ? _formatCount(followers) : '—',
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

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

// MARK: - FAB + Add Sheet

class _AddAccountFab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _showAddSheet(context, ref),
      child: const Icon(Icons.add_rounded),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddAccountSheet(
        onAdd: (platform, username) async {
          await ref.read(accountProvider.notifier).addAccount(
                platform: platform,
                username: username,
              );
        },
      ),
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
    final username = _ctrl.text.trim();
    if (username.isEmpty) {
      setState(() => _error = 'Kullanıcı adı boş olamaz');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.onAdd(_selected, username);
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
            // Platform picker
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: SocialPlatform.values.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final p = SocialPlatform.values[i];
                  final sel = p == _selected;
                  return ChoiceChip(
                    avatar: Icon(p.icon,
                        size: 14,
                        color: sel
                            ? p.brandColor
                            : (isDark ? Colors.white54 : Colors.black45)),
                    label: Text(p.displayName,
                        style: TextStyle(fontSize: 12, color: sel ? p.brandColor : null)),
                    selected: sel,
                    selectedColor: p.brandColor.withValues(alpha: isDark ? 0.25 : 0.15),
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
                  style: const TextStyle(color: Color(0xFFF87171), fontSize: 13)),
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
