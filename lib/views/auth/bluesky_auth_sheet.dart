import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/liquid_glass.dart';

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
    setState(() {
      _loading = true;
      _error = null;
    });
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
              'Bluesky Bağla',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: LiquidGlass.textPrimary(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Uygulama şifresi oluşturun: Ayarlar → Gizlilik → Uygulama Şifreleri',
              style: TextStyle(
                fontSize: 12,
                color: LiquidGlass.textSecondary(context),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _handleCtrl,
              decoration: const InputDecoration(
                labelText: 'Handle (örn: kullanici.bsky.social)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordCtrl,
              decoration: const InputDecoration(
                labelText: 'Uygulama Şifresi',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              obscureText: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Color(0xFFF87171), fontSize: 13),
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
                  : const Text('Bağlan'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
