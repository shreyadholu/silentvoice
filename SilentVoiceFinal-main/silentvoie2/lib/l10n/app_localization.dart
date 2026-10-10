// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  static Map<String, dynamic>? _localizedStrings;

  AppLocalizations(this.locale);

  // Add this line to properly initialize the delegate
  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations appLocalizations = AppLocalizations(locale);
    
    String jsonString = await rootBundle.loadString('lib/l10n/localization.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    _localizedStrings = jsonMap[locale.languageCode];
    
    return appLocalizations;
  }

  String translate(String key) {
    return _localizedStrings?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'ta', 'gu'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
