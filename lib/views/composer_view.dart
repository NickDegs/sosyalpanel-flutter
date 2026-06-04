import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/platform.dart';
import '../providers/auth_provider.dart';
import '../theme/liquid_glass.dart';

class ComposerView extends ConsumerStatefulWidget {
  const ComposerView({super.key});

  @override
  ConsumerState<ComposerView> createState() => _ComposerViewState();
}

class _ComposerViewState extends ConsumerState<ComposerView> {
  final _controller = TextEditingController();
  final Set<SocialPlatform> _selectedPlatforms = {};
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connected = ref.watch(connectedPlatformsProvider);
    final postable = connected.where((p) => p.supportsPosting).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPad = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
    final bottomPad = MediaQuery.paddingOf(context).bottom + 16;
    final canSend = _selectedPlatforms.isNotEmpty &&
        _controller.text.isNotEmpty &&
        !_isSending;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: const Text('Paylaş'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _isSending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FilledButton(
                    onPressed: canSend ? _send : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(60, 34),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Paylaş', style: TextStyle(fontSize: 13)),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: topPad, bottom: bottomPad),
        child: Column(
          children: [
            // Text editor glass panel
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: GlassContainer(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          expands: true,
                          maxLength: 2200,
                          style: TextStyle(
                            color: LiquidGlass.textPrimary(context),
                            fontSize: 16,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ne paylaşmak istiyorsun?',
                            hintStyle: TextStyle(
                              color: LiquidGlass.textSecondary(context),
                            ),
                            border: InputBorder.none,
                            counterStyle: TextStyle(
                              color: LiquidGlass.textSecondary(context),
                              fontSize: 11,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Platform selector glass panel
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: GlassContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Platform Seç',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: LiquidGlass.textSecondary(context),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (postable.isEmpty)
                      Text(
                        'Paylaşım destekleyen hesap bağlı değil.',
                        style: TextStyle(
                            color: LiquidGlass.textSecondary(context)),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: postable.map((p) {
                          final sel = _selectedPlatforms.contains(p);
                          return FilterChip(
                            avatar: Icon(p.icon, size: 16),
                            label: Text(p.displayName),
                            selected: sel,
                            selectedColor: p.brandColor
                                .withValues(alpha: isDark ? 0.3 : 0.2),
                            checkmarkColor: p.brandColor,
                            onSelected: (v) => setState(() =>
                                v ? _selectedPlatforms.add(p) : _selectedPlatforms.remove(p)),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Paylaşım kuyruğa alındı'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      _controller.clear();
      _selectedPlatforms.clear();
      setState(() => _isSending = false);
    }
  }
}
