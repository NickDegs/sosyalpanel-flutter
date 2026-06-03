import 'package:flutter/material.dart';
import '../../models/platform.dart';

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
    setState(() { _loading = true; _error = null; });
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
    return Padding(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(widget.platform.icon, color: widget.platform.brandColor),
              const SizedBox(width: 8),
              Text('${widget.platform.displayName} Bağla',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            decoration: InputDecoration(labelText: widget.label, border: const OutlineInputBorder()),
            autofocus: true,
            onSubmitted: (_) => _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
