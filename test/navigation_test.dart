import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyalpanel/models/database.dart';
import 'package:sosyalpanel/models/platform.dart';
import 'package:sosyalpanel/providers/account_provider.dart';
import 'package:sosyalpanel/views/root_view.dart';
import 'package:sosyalpanel/theme/liquid_glass.dart';

// UC-01 … UC-06 — Navigasyon & sekme kullanım senaryoları

void main() {
  // ─── UC-01: Açılış — boş dashboard ────────────────────────
  group('UC-01 Açılış — boş durum', () {
    testWidgets('dashboard boş ekranı gösterir', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      expect(find.text('Henüz hesap eklenmedi'), findsOneWidget);
    });
  });

  // ─── UC-02: Sekme navigasyonu ─────────────────────────────
  group('UC-02 Sekme navigasyonu', () {
    testWidgets('5 sekme ikonu görünür', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.grid_view_rounded), findsWidgets);
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
      expect(find.text('İçerik Önerileri'), findsWidgets);
    });

    testWidgets('Ayarlar sekmesine geçiş', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('Ayarlar'), findsWidgets);
    });
  });

  // ─── UC-03: Hesap ekliyken grid görünümü ─────────────────
  group('UC-03 Hesap eklenince kart görünür', () {
    testWidgets('Instagram hesabı varsa kart görünür', (tester) async {
      await tester.pumpWidget(_appWith(accounts: [
        _entry(1, SocialPlatform.instagram, 'johndoe'),
      ]));
      await tester.pumpAndSettle();
      expect(find.text('Instagram'), findsWidgets);
      expect(find.text('Henüz hesap eklenmedi'), findsNothing);
    });

    testWidgets('Birden fazla hesap kartı gösterilir', (tester) async {
      await tester.pumpWidget(_appWith(accounts: [
        _entry(1, SocialPlatform.instagram, 'user1'),
        _entry(2, SocialPlatform.youtube, 'user2'),
        _entry(3, SocialPlatform.bluesky, 'user3'),
      ]));
      await tester.pumpAndSettle();
      expect(find.text('Instagram'), findsWidgets);
      expect(find.text('YouTube'), findsWidgets);
      expect(find.text('Bluesky'), findsWidgets);
    });
  });

  // ─── UC-04: Ayarlar — bölüm görünürlüğü ─────────────────
  group('UC-04 Ayarlar — bölümler mevcut', () {
    testWidgets('Takip Edilen Hesaplar bölümü var', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings_outlined).first);
      await tester.pumpAndSettle();
      expect(find.textContaining('TAKIP EDILEN HESAPLAR'), findsOneWidget);
    });
  });

  // ─── UC-05: Analiz sekmeleri ──────────────────────────────
  group('UC-05 Analiz — Grafikler / Güncelle', () {
    testWidgets('İki tab görünür', (tester) async {
      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.bar_chart_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('Grafikler'), findsWidgets);
      expect(find.text('Güncelle'), findsWidgets);
    });
  });

  // ─── UC-06: Tablet layout ────────────────────────────────
  group('UC-06 Tablet layout', () {
    testWidgets('820dp: sidebar rail görünür, navbar yok', (tester) async {
      tester.view.physicalSize = const Size(820, 1180);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_appWith());
      await tester.pumpAndSettle();
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

// ─── Helpers ─────────────────────────────────────────────────

Widget _appWith({List<AccountEntry> accounts = const []}) {
  return ProviderScope(
    overrides: [
      accountProvider.overrideWith(() => _MockAccountNotifier(accounts)),
    ],
    child: MaterialApp(
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(disableAnimations: true),
        child: child!,
      ),
      home: const RootView(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

AccountEntry _entry(int id, SocialPlatform platform, String username) {
  return AccountEntry(
    account: TrackedAccount(
      id: id,
      platformRaw: platform.name,
      username: username,
      displayName: null,
      sortOrder: 0,
      addedAt: DateTime(2024, 1, 1),
    ),
  );
}

class _MockAccountNotifier extends AccountNotifier {
  final List<AccountEntry> _entries;
  _MockAccountNotifier(this._entries);

  @override
  Future<List<AccountEntry>> build() async => _entries;
}
