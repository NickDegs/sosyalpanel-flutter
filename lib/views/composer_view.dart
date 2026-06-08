import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/platform.dart';
import '../services/composer_service.dart';
import '../theme/liquid_glass.dart';
import '../utils/adaptive.dart';
import '../utils/animations.dart';

class ComposerView extends StatefulWidget {
  const ComposerView({super.key});

  @override
  State<ComposerView> createState() => _ComposerViewState();
}

class _ComposerViewState extends State<ComposerView> {
  final _ctrl = TextEditingController();
  final Set<SocialPlatform> _selected = {};
  bool _isSending = false;
  List<ShareResult>? _lastResults;

  static final _postable = SocialPlatform.values
      .where((p) => p.shareMode != ShareMode.video)
      .toList();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool get _canSend =>
      _selected.isNotEmpty && _ctrl.text.isNotEmpty && !_isSending;

  int? get _hardestLimit {
    if (_selected.isEmpty) return null;
    int? min;
    for (final p in _selected) {
      final lim = p.characterLimit;
      if (lim != null && (min == null || lim < min)) min = lim;
    }
    return min;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPad = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
    final bottomPad = MediaQuery.paddingOf(context).bottom + 16;
    final charLen = _ctrl.text.length;
    final limit = _hardestLimit;

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
                    child: CircularProgressIndicator(strokeWidth: 2))
                : PulseGlow(
                    active: _canSend,
                    child: FilledButton(
                      onPressed: _canSend ? _send : null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(60, 34),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Paylaş', style: TextStyle(fontSize: 13)),
                    ),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: topPad, bottom: bottomPad),
        child: Column(
          children: [
            // Text editor
            Expanded(
              child: FadeSlideIn(
                delay: const Duration(milliseconds: 60),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(context.hPad, 0, context.hPad, 8),
                  child: GlassContainer(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _ctrl,
                            maxLines: null,
                            expands: true,
                            style: TextStyle(
                              color: LiquidGlass.textPrimary(context),
                              fontSize: 16,
                              height: 1.5,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ne paylaşmak istiyorsun?',
                              hintStyle: TextStyle(
                                  color: LiquidGlass.textSecondary(context)),
                              border: InputBorder.none,
                            ),
                            onChanged: (_) => setState(() => _lastResults = null),
                          ),
                        ),
                        if (limit != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$charLen / $limit',
                              style: TextStyle(
                                fontSize: 11,
                                color: charLen > limit
                                    ? const Color(0xFFF87171)
                                    : LiquidGlass.textSecondary(context),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Share results banner
            if (_lastResults != null)
              FadeSlideIn(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(context.hPad, 0, context.hPad, 8),
                  child: _ResultsBanner(results: _lastResults!),
                ),
              ),

            // Platform selector
            FadeSlideIn(
              delay: const Duration(milliseconds: 160),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.hPad),
                child: GlassContainer(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'PLATFORM SEÇ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: LiquidGlass.textSecondary(context),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const Spacer(),
                          if (_selected.isNotEmpty)
                            GestureDetector(
                              onTap: () => setState(() => _selected.clear()),
                              child: Text(
                                'Temizle',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _postable.map((p) {
                          final sel = _selected.contains(p);
                          final isClip = p.shareMode == ShareMode.clipboard;
                          return FilterChip(
                            avatar: Icon(p.icon, size: 14),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(p.displayName),
                                if (isClip) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.content_copy_rounded,
                                    size: 10,
                                    color: LiquidGlass.textSecondary(context),
                                  ),
                                ],
                              ],
                            ),
                            selected: sel,
                            selectedColor:
                                p.brandColor.withValues(alpha: isDark ? 0.3 : 0.2),
                            checkmarkColor: p.brandColor,
                            onSelected: (v) => setState(() =>
                                v ? _selected.add(p) : _selected.remove(p)),
                          );
                        }).toList(),
                      ),
                      if (_selected.any((p) => p.shareMode == ShareMode.clipboard)) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 12,
                                color: LiquidGlass.textSecondary(context)),
                            const SizedBox(width: 4),
                            Text(
                              'Bazı platformlar için metin kopyalanır.',
                              style: TextStyle(
                                fontSize: 11,
                                color: LiquidGlass.textSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _selected.isEmpty) return;

    setState(() {
      _isSending = true;
      _lastResults = null;
    });

    final results = await ComposerService.shared.shareToAll(
      _selected.toList(),
      text,
    );

    if (mounted) {
      setState(() {
        _isSending = false;
        _lastResults = results;
      });

      final clipboards = results.where((r) => r.usedClipboard).toList();
      if (clipboards.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${clipboards.map((r) => r.platform.displayName).join(', ')} için metin kopyalandı — uygulamada yapıştır',
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }
}

class _ResultsBanner extends StatelessWidget {
  final List<ShareResult> results;
  const _ResultsBanner({required this.results});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: results.map((r) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                r.success
                    ? (r.usedClipboard
                        ? Icons.content_copy_rounded
                        : Icons.check_circle_rounded)
                    : Icons.error_outline_rounded,
                size: 14,
                color: r.success ? const Color(0xFF34D399) : const Color(0xFFF87171),
              ),
              const SizedBox(width: 4),
              Text(
                r.platform.displayName,
                style: TextStyle(
                  fontSize: 12,
                  color: LiquidGlass.textPrimary(context),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
