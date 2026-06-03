import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/platform.dart';
import '../providers/auth_provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paylaş'),
        actions: [
          TextButton(
            onPressed: (_selectedPlatforms.isNotEmpty && _controller.text.isNotEmpty && !_isSending)
                ? _send
                : null,
            child: _isSending
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Paylaş'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                maxLines: null,
                maxLength: 2200,
                decoration: const InputDecoration(
                  hintText: 'Ne paylaşmak istiyorsun?',
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Platform Seç', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                if (postable.isEmpty)
                  const Text('Paylaşım destekleyen hesap bağlı değil.', style: TextStyle(color: Colors.grey))
                else
                  Wrap(
                    spacing: 8,
                    children: postable.map((p) {
                      final sel = _selectedPlatforms.contains(p);
                      return FilterChip(
                        avatar: Icon(p.icon, size: 16),
                        label: Text(p.displayName),
                        selected: sel,
                        selectedColor: p.brandColor.withValues(alpha: 0.15),
                        onSelected: (v) => setState(() => v ? _selectedPlatforms.add(p) : _selectedPlatforms.remove(p)),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 1)); // Backend çağrısı
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paylaşım kuyruğa alındı')),
      );
      _controller.clear();
      _selectedPlatforms.clear();
      setState(() => _isSending = false);
    }
  }
}
