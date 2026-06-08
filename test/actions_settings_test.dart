import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyalpanel/providers/account_provider.dart';
import 'package:sosyalpanel/views/actions_view.dart';
import 'package:sosyalpanel/views/settings/settings_view.dart';

// UC-11 … UC-14 — İçerik Önerileri & Ayarlar

void main() {
  // ─── UC-11: İçerik Önerileri ─────────────────────────────
  group('UC-11 İçerik Önerileri — bölüm başlıkları', () {
    testWidgets('"En İyi Paylaşım Saatleri" bölümü görünür', (tester) async {
      await tester.pumpWidget(_wrap(const ActionsView()));
      await tester.pumpAndSettle();
      expect(find.text('En İyi Paylaşım Saatleri'), findsOneWidget);
    });

    testWidgets('"İçerik Fikirleri" bölümü görünür', (tester) async {
      await tester.pumpWidget(_wrap(const ActionsView()));
      await tester.pumpAndSettle();
      expect(find.text('İçerik Fikirleri'), findsOneWidget);
    });

    testWidgets('Gizlilik notu görünür', (tester) async {
      await tester.pumpWidget(_wrap(const ActionsView()));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
            'Bu uygulama hesaplarınızda otomatik aksiyon ALMAZ'),
        findsOneWidget,
      );
    });
  });

  // ─── UC-12: Ayarlar — bölüm başlıkları ──────────────────
  group('UC-12 Ayarlar — bölümler', () {
    testWidgets('Tüm bölüm başlıkları görünür', (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(_wrapSettings());
      await tester.pumpAndSettle();
      // Dart toUpperCase: 'i' → 'I' (locale-bağımsız, 'İ' değil)
      expect(find.text('TAKIP EDILEN HESAPLAR'), findsOneWidget);
      expect(find.text('DIL / LANGUAGE'), findsOneWidget);
      expect(find.text('UYGULAMA'), findsOneWidget);
    });

    testWidgets('Sürüm 1.0.0 görünür', (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(_wrapSettings());
      await tester.pumpAndSettle();
      expect(find.text('1.0.0'), findsOneWidget);
    });
  });

  // ─── UC-13: Ayarlar — Platformları Aç bölümü ────────────
  group('UC-13 Ayarlar — Platformları Aç', () {
    testWidgets('"Platformları Aç" bölümü görünür', (tester) async {
      await tester.pumpWidget(_wrapSettings());
      await tester.pumpAndSettle();
      expect(find.text('PLATFORMLARI AÇ'), findsOneWidget);
    });

    testWidgets('Instagram tile görünür', (tester) async {
      await tester.pumpWidget(_wrapSettings());
      await tester.pumpAndSettle();
      expect(find.text('Instagram'), findsWidgets);
    });
  });

  // ─── UC-14: Ayarlar — dil seçici ────────────────────────
  group('UC-14 Ayarlar — dil seçici', () {
    testWidgets('Uygulama Dili tile\'ı görünür', (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(_wrapSettings());
      await tester.pumpAndSettle();
      expect(find.text('Uygulama Dili'), findsOneWidget);
    });
  });
}

// ─── Helpers ─────────────────────────────────────────────────

Widget _wrap(Widget w) => ProviderScope(
      overrides: [
        accountProvider.overrideWith(() => _MockAccountNotifier()),
      ],
      child: MaterialApp(
        builder: (ctx, child) => MediaQuery(
          data: MediaQuery.of(ctx).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: Scaffold(body: w),
        debugShowCheckedModeBanner: false,
      ),
    );

Widget _wrapSettings() => ProviderScope(
      overrides: [
        accountProvider.overrideWith(() => _MockAccountNotifier()),
      ],
      child: MaterialApp(
        builder: (ctx, child) => MediaQuery(
          data: MediaQuery.of(ctx).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: const SettingsView(),
        debugShowCheckedModeBanner: false,
      ),
    );

class _MockAccountNotifier extends AccountNotifier {
  @override
  Future<List<AccountEntry>> build() async => [];
}
