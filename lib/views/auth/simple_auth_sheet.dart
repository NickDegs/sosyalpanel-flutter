import 'package:flutter/material.dart';
import '../../models/platform.dart';
import '../../theme/liquid_glass.dart';

class SimpleAuthSheet extends StatefulWidget {
  final SocialPlatform platform;
  final String label;
  final Future<void> Function(String value) onSuccess;

  const SimpleAuthSheet({
    super.key,
    required this.platform,
    required this.label,
    required this.onSuccess,
  });

  @override
  State<SimpleAuthSheet> createState() => _SimpleAuthSheetState();
}

class _SimpleAuthSheetState extends State<SimpleAuthSheet> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.onSuccess(_ctrl.text.trim());
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.platform.brandColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.platform.icon,
                      color: widget.platform.brandColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  '${widget.platform.displayName} Bağla',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: LiquidGlass.textPrimary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                labelText: widget.label,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              autofocus: true,
              onSubmitted: (_) => _submit(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style:
                    const TextStyle(color: Color(0xFFF87171), fontSize: 13),
              ),
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
                  : const Text('Kaydet'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
