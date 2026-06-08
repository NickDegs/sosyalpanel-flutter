import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/platform.dart';

class ShareResult {
  final SocialPlatform platform;
  final bool success;
  final bool usedClipboard;

  const ShareResult({
    required this.platform,
    required this.success,
    this.usedClipboard = false,
  });
}

class ComposerService {
  ComposerService._();
  static final ComposerService shared = ComposerService._();

  Future<List<ShareResult>> shareToAll(
    List<SocialPlatform> platforms,
    String text,
  ) async {
    final results = <ShareResult>[];
    for (final p in platforms) {
      results.add(await shareTo(p, text));
    }
    return results;
  }

  Future<ShareResult> shareTo(SocialPlatform platform, String text) async {
    switch (platform.shareMode) {
      case ShareMode.url:
        final url = platform.shareUrl(text);
        if (url != null) {
          final launched = await _tryLaunch(url);
          return ShareResult(platform: platform, success: launched);
        }
        return ShareResult(platform: platform, success: false);

      case ShareMode.clipboard:
        await Clipboard.setData(ClipboardData(text: text));
        final opened = await _openApp(platform);
        return ShareResult(platform: platform, success: opened, usedClipboard: true);

      case ShareMode.video:
        final opened = await _openApp(platform);
        return ShareResult(platform: platform, success: opened);
    }
  }

  Future<bool> openApp(SocialPlatform platform) => _openApp(platform);

  Future<bool> _openApp(SocialPlatform platform) async {
    final scheme = platform.nativeScheme;
    if (scheme != null) {
      final launched = await _tryLaunch(scheme);
      if (launched) return true;
    }
    return _tryLaunch(platform.webUrl);
  }

  Future<bool> _tryLaunch(String urlStr) async {
    final uri = Uri.parse(urlStr);
    try {
      if (await canLaunchUrl(uri)) {
        return launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
