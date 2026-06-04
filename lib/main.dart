import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/locale_provider.dart';
import 'services/store_manager.dart';
import 'views/root_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoreManager.shared.init();
  runApp(const ProviderScope(child: SocialPanelApp()));
}

class SocialPanelApp extends ConsumerWidget {
  const SocialPanelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final code = locale?.languageCode ?? 'en';
    final title = appNameByLocale[code] ?? 'Social Panel';
    return MaterialApp(
      title: title,
      locale: locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C5CE7),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C5CE7),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('pt'),
        Locale('ru'),
        Locale('ar'),
        Locale('zh'),
        Locale('hi'),
        Locale('uk'),
        Locale('az'),
        Locale('kk'),
      ],
      home: const RootView(),
    );
  }
}
