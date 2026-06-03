import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/platform.dart';

class KeychainService {
  KeychainService._();
  static final KeychainService shared = KeychainService._();

  final _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device),
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  String _key(SocialPlatform platform) => 'token_${platform.name}';

  Future<void> saveToken(SocialPlatform platform, String token) =>
      _storage.write(key: _key(platform), value: token);

  Future<String> readToken(SocialPlatform platform) async {
    final val = await _storage.read(key: _key(platform));
    if (val == null) throw Exception('Token bulunamadı: ${platform.displayName}');
    return val;
  }

  Future<bool> hasToken(SocialPlatform platform) async =>
      await _storage.read(key: _key(platform)) != null;

  Future<void> deleteToken(SocialPlatform platform) =>
      _storage.delete(key: _key(platform));

  Future<void> deleteAll() => _storage.deleteAll();
}
