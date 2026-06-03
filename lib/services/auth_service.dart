import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/platform.dart';
import 'keychain_service.dart';
import 'config.dart';

class AuthService {
  AuthService._();
  static final AuthService shared = AuthService._();

  Future<void> connect(SocialPlatform platform, {String? instanceHost}) async {
    switch (platform.authMode) {
      case AuthMode.oauth2:
        await _oauth2Flow(platform);
      case AuthMode.oauth2PerInstance:
        await _mastodonFlow(instanceHost ?? 'mastodon.social');
      case AuthMode.appPassword:
        throw UnsupportedError('Bluesky için BlueskyAuthSheet kullan');
      case AuthMode.apiKey:
        throw UnsupportedError('Dev.to için ApiKeySheet kullan');
      case AuthMode.botToken:
        throw UnsupportedError('Telegram için BotTokenSheet kullan');
      case AuthMode.webhook:
        throw UnsupportedError('Discord için WebhookSheet kullan');
    }
  }

  // MARK: - OAuth2

  Future<void> _oauth2Flow(SocialPlatform platform) async {
    final cfg = Config.oauth(platform);
    final authUrl = cfg.authorizationUrl;
    final callbackScheme = 'sosyalpanel';

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: callbackScheme,
    );

    final uri = Uri.parse(result);
    final code = uri.queryParameters['code']!;

    // Backend'e code → token exchange
    final resp = await http.post(
      Uri.parse('${Config.backendUrl}/oauth/callback/${platform.name}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'code': code}),
    );

    if (resp.statusCode != 200) {
      throw Exception('Token alınamadı: ${resp.body}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final token = data['access_token'] as String;
    await KeychainService.shared.saveToken(platform, token);
  }

  // MARK: - Mastodon per-instance

  Future<void> _mastodonFlow(String host) async {
    final prefs = await SharedPreferences.getInstance();

    // App kayıt
    final regResp = await http.post(
      Uri.parse('https://$host/api/v1/apps'),
      body: {
        'client_name': 'SosyalPanel',
        'redirect_uris': 'sosyalpanel://oauth/mastodon',
        'scopes': 'read write',
        'website': 'https://realvirtuality.app',
      },
    );
    final regData = jsonDecode(regResp.body) as Map<String, dynamic>;
    final clientId = regData['client_id'] as String;
    final clientSecret = regData['client_secret'] as String;

    final authUrl = Uri.parse(
      'https://$host/oauth/authorize'
      '?client_id=$clientId'
      '&redirect_uri=sosyalpanel://oauth/mastodon'
      '&response_type=code'
      '&scope=read+write',
    ).toString();

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: 'sosyalpanel',
    );

    final code = Uri.parse(result).queryParameters['code']!;

    final tokenResp = await http.post(
      Uri.parse('https://$host/oauth/token'),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'redirect_uri': 'sosyalpanel://oauth/mastodon',
        'grant_type': 'authorization_code',
        'code': code,
        'scope': 'read write',
      },
    );
    final tokenData = jsonDecode(tokenResp.body) as Map<String, dynamic>;
    final token = tokenData['access_token'] as String;

    await KeychainService.shared.saveToken(SocialPlatform.mastodon, token);
    await prefs.setString('mastodon.instance', host);
  }

  // MARK: - Bluesky (handle + app password)

  Future<void> connectBluesky({
    required String handle,
    required String appPassword,
  }) async {
    final resp = await http.post(
      Uri.parse('https://bsky.social/xrpc/com.atproto.server.createSession'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifier': handle, 'password': appPassword}),
    );
    if (resp.statusCode != 200) throw Exception('Bluesky giriş başarısız');
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final token = data['accessJwt'] as String;
    final did = data['did'] as String;

    await KeychainService.shared.saveToken(SocialPlatform.bluesky, token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bsky.did', did);
    await prefs.setString('bsky.handle', handle);
  }

  // MARK: - Simple credential saves

  Future<void> saveApiKey(SocialPlatform platform, String key) =>
      KeychainService.shared.saveToken(platform, key);

  Future<void> disconnect(SocialPlatform platform) async {
    await KeychainService.shared.deleteToken(platform);
    if (platform == SocialPlatform.mastodon) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('mastodon.instance');
    }
    if (platform == SocialPlatform.bluesky) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('bsky.did');
      await prefs.remove('bsky.handle');
    }
  }
}
