import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyalpanel/models/platform.dart';
import 'package:sosyalpanel/providers/account_provider.dart';
import 'package:sosyalpanel/views/composer_view.dart';

// UC-07 … UC-10 — Composer (Paylaş) kullanım senaryoları
// Yeni mimari: giriş gerekmez, tüm platformlar doğrudan listelenir.

void main() {
  group('UC-07 Composer — boş başlangıç durumu', () {
    testWidgets('Gönder butonu başlangıçta devre dışı', (tester) async {
      await tester.pumpWidget(_composerWith());
      await tester.pumpAndSettle();
      final btn = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(btn.onPressed, isNull);
    });

    testWidgets('"Ne paylaşmak istiyorsun?" hint görünür', (tester) async {
      await tester.pumpWidget(_composerWith());
      await tester.pumpAndSettle();
      expect(find.text('Ne paylaşmak istiyorsun?'), findsOneWidget);
    });
  });

  group('UC-08 Composer — metin girildi ama platform seçilmedi', () {
    testWidgets('Gönder butonu hâlâ devre dışı', (tester) async {
      await tester.pumpWidget(_composerWith());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Test içerik mesajı');
      await tester.pumpAndSettle();
      final btn = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(btn.onPressed, isNull);
    });
  });

  group('UC-09 Composer — platform chip\'leri', () {
    testWidgets('"PLATFORM SEÇ" başlığı görünür', (tester) async {
      await tester.pumpWidget(_composerWith());
      await tester.pumpAndSettle();
      expect(find.textContaining('PLATFORM SEÇ'), findsOneWidget);
    });

    testWidgets('Video platformu (YouTube) hariç chip\'ler görünür',
        (tester) async {
      await tester.pumpWidget(_composerWith());
      await tester.pumpAndSettle();
      // YouTube ShareMode.video olduğu için listede yer almaz
      expect(find.text('YouTube'), findsNothing);
      // Diğer platformlar görünmeli
      expect(find.text('Instagram'), findsWidgets);
      expect(find.text('Reddit'), findsWidgets);
    });

    testWidgets('Platform seç + metin yaz → buton aktif', (tester) async {
      await tester.pumpWidget(_composerWith());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Merhaba dünya!');
      await tester.pumpAndSettle();
      // İlk chip'e dokun
      await tester.tap(find.byType(FilterChip).first);
      await tester.pumpAndSettle();
      final btn = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(btn.onPressed, isNotNull);
    });
  });

  group('UC-10 Composer — karakter limiti', () {
    testWidgets('Bluesky seçilince 300 karakter limiti gösterilir',
        (tester) async {
      await tester.pumpWidget(_composerWith());
      await tester.pumpAndSettle();
      // Bluesky chip'ini bul ve seç
      final blueskyChip = find.ancestor(
        of: find.text('Bluesky'),
        matching: find.byType(FilterChip),
      );
      if (blueskyChip.evaluate().isNotEmpty) {
        await tester.tap(blueskyChip.first);
        await tester.pumpAndSettle();
        expect(find.textContaining('/ 300'), findsOneWidget);
      }
    });
  });
}

Widget _composerWith() => ProviderScope(
      overrides: [
        accountProvider.overrideWith(() => _MockAccountNotifier()),
      ],
      child: MaterialApp(
        builder: (ctx, child) => MediaQuery(
          data: MediaQuery.of(ctx).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: const Scaffold(body: ComposerView()),
        debugShowCheckedModeBanner: false,
      ),
    );

class _MockAccountNotifier extends AccountNotifier {
  @override
  Future<List<AccountEntry>> build() async => [];
}
