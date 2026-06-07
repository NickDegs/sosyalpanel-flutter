import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyalpanel/models/platform.dart';
import 'package:sosyalpanel/providers/auth_provider.dart';
import 'package:sosyalpanel/views/actions_view.dart';
import 'package:sosyalpanel/views/settings/settings_view.dart';

// UC-11 … UC-14 — Aksiyon Merkezi & Ayarlar

void main() {
  // ─── UC-11: Aksiyon Merkezi ──────────────────────────────────
  group('UC-11 Aksiyon Merkezi — içerik', () {
    testWidgets('İçgörüler bölümü görünür', (tester) async {
      await tester.pumpWidget(_wrap(const ActionsView()));
      await tester.pumpAndSettle();
      expect(find.text('İçgörüler'), findsOneWidget);
    });

    testWidgets('Yapılacak Aksiyonlar bölümü görünür', (tester) async {
      await tester.pumpWidget(_wrap(const ActionsView()));
      await tester.pumpAndSettle();
      expect(find.text('Yapılacak Aksiyonlar'), findsOneWidget);
    });

    testWidgets('Gizlilik notu görünür', (tester) async {
      await tester.pumpWidget(_wrap(const ActionsView()));
      await tester.pumpAndSettle();
      expect(
          find.textContaining(
              'Bu uygulama hesaplarınızda otomatik aksiyon ALMAZ'),
          findsOneWidget);
    });
  });

  // ─── UC-12: Ayarlar — bölüm başlıkları ─────────────────────
  group('UC-12 Ayarlar — bölümler', () {
    testWidgets('Tüm bölüm başlıkları görünür', (tester) async {
      await tester.pumpWidget(_wrapSettings());
      await tester.pumpAndSettle();
      expect(find.text('BAĞLI HESAPLAR'), findsOneWidget);
      expect(find.text('DİL / LANGUAGE'), findsOneWidget);
      expect(find.text('UYGULAMA'), findsOneWidget);
    });

    testWidgets('Sürüm 1.0.0 görünür', (tester) async {
      await tester.pumpWidget(_wrapSettings());
      await tester.pumpAndSettle();
      expect(find.text('1.0.0'), findsOneWidget);
    });
  });

  // ─── UC-13: Ayarlar — 14 platform sayısı ────────────────────
  group('UC-13 Ayarlar — 14 platform', () {
    testWidgets('14 platform tile sayısı doğru', (tester) async {
      await tester.pumpWidget(_wrapSettings());
      await tester.pumpAndSettle();
      expect(find.text('Bağlı değil').evaluate().length,
          SocialPlatform.values.length);
    });
  });

  // ─── UC-14: Ayarlar — dil seçici ────────────────────────────
  group('UC-14 Ayarlar — dil seçici', () {
    testWidgets('Uygulama Dili tile\'ı görünür', (tester) async {
      await tester.pumpWidget(_wrapSettings());
      await tester.pumpAndSettle();
      expect(find.text('Uygulama Dili'), findsOneWidget);
    });
  });
}

Widget _wrap(Widget child) => ProviderScope(
      overrides: [
        authProvider.overrideWith(
            () => _MockAuthNotifier({})),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
        debugShowCheckedModeBanner: false,
      ),
    );

Widget _wrapSettings() => ProviderScope(
      overrides: [
        authProvider.overrideWith(
            () => _MockAuthNotifier({})),
      ],
      child: const MaterialApp(
        home: SettingsView(),
        debugShowCheckedModeBanner: false,
      ),
    );

class _MockAuthNotifier extends AuthNotifier {
  final Set<SocialPlatform> _connected;
  _MockAuthNotifier(this._connected);

  @override
  Future<AuthState> build() async =>
      AuthState(connected: _connected);
}
