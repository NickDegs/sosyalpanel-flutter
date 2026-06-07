import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyalpanel/models/platform.dart';
import 'package:sosyalpanel/providers/auth_provider.dart';
import 'package:sosyalpanel/views/composer_view.dart';

// UC-07 … UC-10 — Composer (Paylaş) kullanım senaryoları

void main() {
  group('UC-07 Composer — boş başlangıç durumu', () {
    testWidgets('Gönder butonu başlangıçta devre dışı', (tester) async {
      await tester.pumpWidget(_composerWith(connected: {}));
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
      await tester.pumpWidget(
          _composerWith(connected: {SocialPlatform.instagram}));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(TextField), 'Test içerik mesajı');
      await tester.pumpAndSettle();
      final btn = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(btn.onPressed, isNull);
    });
  });

  group('UC-09 Composer — platform seçimi', () {
    testWidgets('Desteklenen platform chip\'leri gösterilir', (tester) async {
      await tester.pumpWidget(_composerWith(
          connected: {SocialPlatform.instagram, SocialPlatform.bluesky}));
      await tester.pumpAndSettle();
      // Platform Seç paneli ComposerView'da her zaman görünürdür
      expect(find.text('Platform Seç'), findsOneWidget);
      expect(find.byType(FilterChip), findsWidgets);
    });

    testWidgets('Platform seç + metin yaz → buton aktif', (tester) async {
      await tester.pumpWidget(
          _composerWith(connected: {SocialPlatform.bluesky}));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(TextField), 'Merhaba dünya!');
      await tester.pumpAndSettle();
      final chips = find.byType(FilterChip);
      if (chips.evaluate().isNotEmpty) {
        await tester.tap(chips.first);
        await tester.pumpAndSettle();
        final btn = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(btn.onPressed, isNotNull);
      }
    });
  });

  group('UC-10 Composer — bağlı platform yok', () {
    testWidgets('"Paylaşım destekleyen hesap bağlı değil" gösterilir',
        (tester) async {
      await tester.pumpWidget(_composerWith(connected: {}));
      await tester.pumpAndSettle();
      expect(find.text('Paylaşım destekleyen hesap bağlı değil.'),
          findsOneWidget);
    });
  });
}

Widget _composerWith({Set<SocialPlatform> connected = const {}}) =>
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => _MockAuthNotifier(connected)),
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

class _MockAuthNotifier extends AuthNotifier {
  final Set<SocialPlatform> _connected;
  _MockAuthNotifier(this._connected);

  @override
  Future<AuthState> build() async =>
      AuthState(connected: _connected);
}
