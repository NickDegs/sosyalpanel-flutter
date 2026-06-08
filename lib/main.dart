import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/locale_provider.dart';
import 'services/ad_service.dart';
import 'services/store_manager.dart';
import 'theme/liquid_glass.dart';
import 'views/root_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoreManager.shared.init();
  await AdService.shared.initialize();
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
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
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

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseTextTheme = GoogleFonts.nunitoTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );
    return ThemeData(
      colorSchemeSeed: LiquidGlass.colorSeed,
      brightness: brightness,
      useMaterial3: true,
      textTheme: baseTextTheme,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(
          color: isDark ? const Color(0x28FFFFFF) : const Color(0x40000000),
          width: 0.5,
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 12,
        ),
        backgroundColor:
            isDark ? const Color(0x18FFFFFF) : const Color(0x20000000),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? const Color(0x28FFFFFF) : const Color(0x28000000),
        thickness: 0.5,
      ),
      listTileTheme: ListTileThemeData(
        textColor: isDark ? Colors.white : const Color(0xFF1A1035),
        iconColor: isDark ? Colors.white70 : const Color(0xFF6B5EA7),
      ),
    );
  }
}
