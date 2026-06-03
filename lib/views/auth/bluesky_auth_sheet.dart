import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class BlueskyAuthSheet extends StatefulWidget {
  final VoidCallback onSuccess;
  const BlueskyAuthSheet({super.key, required this.onSuccess});

  @override
  State<BlueskyAuthSheet> createState() => _BlueskyAuthSheetState();
}

class _BlueskyAuthSheetState extends State<BlueskyAuthSheet> {
  final _handleCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _handleCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _loading = true; _error = null; });
    try {
      await AuthService.shared.connectBluesky(
        handle: _handleCtrl.text.trim(),
        appPassword: _passwordCtrl.text.trim(),
      );
      widget.onSuccess();
    } catch (e) {
      setState(() => _error = e.toString());
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
          const Text('Bluesky Bağla', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Uygulama şifresi oluşturun: Ayarlar → Gizlilik → Uygulama Şifreleri',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          TextField(
            controller: _handleCtrl,
            decoration: const InputDecoration(labelText: 'Handle (örn: kullanici.bsky.social)', border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordCtrl,
            decoration: const InputDecoration(labelText: 'Uygulama Şifresi', border: OutlineInputBorder()),
            obscureText: true,
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Bağlan'),
          ),
        ],
      ),
    );
  }
}
