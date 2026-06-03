import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/platform.dart';
import '../services/keychain_service.dart';

class AuthState {
  final Set<SocialPlatform> connected;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.connected = const {},
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    Set<SocialPlatform>? connected,
    bool? isLoading,
    String? error,
  }) =>
      AuthState(
        connected: connected ?? this.connected,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    return _loadConnected();
  }

  Future<AuthState> _loadConnected() async {
    final connected = <SocialPlatform>{};
    for (final p in SocialPlatform.values) {
      if (await KeychainService.shared.hasToken(p)) {
        connected.add(p);
      }
    }
    return AuthState(connected: connected);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadConnected());
  }

  Future<void> disconnect(SocialPlatform platform) async {
    await KeychainService.shared.deleteToken(platform);
    await reload();
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final connectedPlatformsProvider = Provider<Set<SocialPlatform>>((ref) {
  return ref.watch(authProvider).valueOrNull?.connected ?? {};
});
