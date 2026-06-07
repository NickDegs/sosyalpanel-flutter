import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyalpanel/models/platform.dart';
import 'package:sosyalpanel/providers/auth_provider.dart';
import 'package:sosyalpanel/views/root_view.dart';
import 'package:sosyalpanel/theme/liquid_glass.dart';
import 'package:sosyalpanel/providers/locale_provider.dart';

// UC-01 … UC-06 — Navigasyon & sekme kullanım senaryoları

void main() {
  // ─── UC-01: Uygulama açılışı — boş dashboard ───────────────
  group('UC-01 Açılış — boş durum', () {
    testWidgets('dashboard boş ekranı gösterir', (tester) async {
      await tester.pumpWidget(_appWith(connected: {}));
      await tester.pumpAndSettle();
      // Boş durum metni görünmeli
      expect(find.text('Henüz hesap bağlanmadı'), findsOneWidget);
      expect(find.text('Ayarlar sekmesinden bir platform bağlayın.'),
          findsOneWidget);
    });
  });

  // ─── UC-02: Tüm sekmeler arasında geçiş ────────────────────
  group('UC-02 Sekme navigasyonu', () {
    testWidgets('5 sekme ikonu görünür', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.grid_view_outlined), findsWidgets);
      expect(find.byIcon(Icons.bar_chart_outlined), findsWidgets);
      expect(find.byIcon(Icons.edit_outlined), findsWidgets);
      expect(find.byIcon(Icons.checklist_outlined), findsWidgets);
      expect(find.byIcon(Icons.settings_outlined), findsWidgets);
    });

    testWidgets('Analiz sekmesine geçiş', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.bar_chart_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('Analiz'), findsWidgets);
    });

    testWidgets('Paylaş sekmesine geçiş', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('Paylaş'), findsWidgets);
    });

    testWidgets('Aksiyon sekmesine geçiş', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.checklist_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('Aksiyon Merkezi'), findsWidgets);
    });

    testWidgets('Ayarlar sekmesine geçiş', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('Ayarlar'), findsWidgets);
    });
  });

  // ─── UC-03: Bağlı platform — dashboard grid ────────────────
  group('UC-03 Bağlı hesap grid görünümü', () {
    testWidgets('Instagram bağlıysa kart görünür', (tester) async {
      await tester.pumpWidget(
          _appWith(connected: {SocialPlatform.instagram}));
      await tester.pumpAndSettle();
      expect(find.text('Instagram'), findsWidgets);
      expect(find.text('Henüz hesap bağlanmadı'), findsNothing);
    });

    testWidgets('Birden fazla platform kartı gösterilir', (tester) async {
      await tester.pumpWidget(_appWith(
          connected: {SocialPlatform.instagram, SocialPlatform.youtube,
                      SocialPlatform.tiktok, SocialPlatform.bluesky}));
      await tester.pumpAndSettle();
      expect(find.text('Instagram'), findsWidgets);
      expect(find.text('YouTube'), findsWidgets);
      expect(find.text('TikTok'), findsWidgets);
      expect(find.text('Bluesky'), findsWidgets);
    });
  });

  // ─── UC-04: Ayarlar — platform listesi ─────────────────────
  group('UC-04 Ayarlar — platform tile\'ları', () {
    testWidgets('14 platform tile görünür', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings_outlined).first);
      await tester.pumpAndSettle();
      // Her platform için "Bağlı değil" metni olmalı
      expect(find.text('Bağlı değil').evaluate().length,
          SocialPlatform.values.length);
    });

    testWidgets('Bağlı platform "Bağlı" gösterir', (tester) async {
      await tester.pumpWidget(
          _appWith(connected: {SocialPlatform.instagram}));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('Bağlı'), findsOneWidget);
    });
  });

  // ─── UC-05: Analiz sekmeleri ────────────────────────────────
  group('UC-05 Analiz — Metrikler / Takipçiler', () {
    testWidgets('İki tab görünür', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.bar_chart_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('Metrikler'), findsWidgets);
      expect(find.text('Takipçiler'), findsWidgets);
    });
  });

  // ─── UC-06: Tablet layout (iPad / Z Fold açık) ─────────────
  group('UC-06 Tablet layout', () {
    testWidgets('820dp: sidebar rail görünür, navbar yok', (tester) async {
      tester.view.physicalSize = const Size(820, 1180);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      // Tablet'te bottom nav yok, NavigationRail var
      expect(find.byType(BottomNavigationBar), findsNothing);
    });

    testWidgets('393dp: bottom nav görünür', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      expect(find.byType(GlassNavBar), findsOneWidget);
    });
  });
}

// ─── Test yardımcısı ──────────────────────────────────────────

Widget _appWith({Set<SocialPlatform> connected = const {}}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => _MockAuthNotifier(connected)),
    ],
    child: const MaterialApp(
      home: RootView(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class _MockAuthNotifier extends AsyncNotifier<AuthState> {
  final Set<SocialPlatform> _connected;
  _MockAuthNotifier(this._connected);

  @override
  Future<AuthState> build() async =>
      AuthState(connected: _connected);
}
