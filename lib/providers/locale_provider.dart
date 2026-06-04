import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefKey = 'app_locale';

// Her dilde uygulama adı
const Map<String, String> appNameByLocale = {
  'tr': 'Sosyal Panel',
  'en': 'Social Panel',
  'es': 'Panel Social',
  'fr': 'Panneau Social',
  'de': 'Social Panel',
  'it': 'Pannello Social',
  'pt': 'Painel Social',
  'ru': 'Социальная Панель',
  'ar': 'لوحة التواصل',
  'zh': '社交面板',
  'hi': 'सोशल पैनल',
  'uk': 'Соціальна Панель',
  'az': 'Sosial Panel',
  'kk': 'Әлеуметтік Панель',
};

// Her dil için görünen isim (dil seçici listesi için)
const Map<String, String> languageNames = {
  'tr': 'Türkçe',
  'en': 'English',
  'es': 'Español',
  'fr': 'Français',
  'de': 'Deutsch',
  'it': 'Italiano',
  'pt': 'Português',
  'ru': 'Русский',
  'ar': 'العربية',
  'zh': '中文',
  'hi': 'हिन्दी',
  'uk': 'Українська',
  'az': 'Azərbaycanca',
  'kk': 'Қазақша',
};

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    _load();
    return null; // sistem dili varsayılan
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(String? languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    if (languageCode == null) {
      await prefs.remove(_prefKey);
      state = null;
    } else {
      await prefs.setString(_prefKey, languageCode);
      state = Locale(languageCode);
    }
  }

  String appName(BuildContext context) {
    final code = state?.languageCode ??
        Localizations.localeOf(context).languageCode;
    return appNameByLocale[code] ?? 'Social Panel';
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);
