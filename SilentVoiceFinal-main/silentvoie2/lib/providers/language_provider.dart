// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String LANGUAGE_KEY = 'language_code';
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String languageCode = prefs.getString(LANGUAGE_KEY) ?? 'en';
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (!['en', 'hi', 'ta', 'gu'].contains(languageCode)) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_KEY, languageCode);
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }
}