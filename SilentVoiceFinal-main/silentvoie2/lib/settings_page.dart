// ignore_for_file: unused_import, unused_element
/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localization.dart';
import 'providers/language_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Locale _currentLocale = const Locale('en', ''); // Default language (English)

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  // Load saved language preference
  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code') ?? 'en';
    setState(() {
      _currentLocale = Locale(langCode, '');
    });
  }

  // Save and apply selected language
  Future<void> _changeLanguage(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    setState(() {
      _currentLocale = locale;
    });
  }

  void _updateLanguage(String languageCode) {
    Provider.of<LanguageProvider>(context, listen: false)
        .changeLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      locale: _currentLocale,
      supportedLocales: [
        Locale('en', ''), // English
        Locale('hi', ''), // Hindi 
        Locale('ta', ''), // Tamil
        Locale('gu', ''), // Gujarati
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate("settings")),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(AppLocalizations.of(context)!.translate("general_settings")),
              _buildLanguagePreferenceItem(),
              _buildSettingItem(Icons.dark_mode, AppLocalizations.of(context)!.translate("dark_mode")),
              _buildSettingItem(Icons.notifications, AppLocalizations.of(context)!.translate("notifications")),
              
              const SizedBox(height: 20),
              _buildSectionTitle(AppLocalizations.of(context)!.translate("support_legal")),
              _buildSettingItem(Icons.help, AppLocalizations.of(context)!.translate("help_faq")),
              _buildSettingItem(Icons.feedback, AppLocalizations.of(context)!.translate("feedback")),
              _buildSettingItem(Icons.description, AppLocalizations.of(context)!.translate("terms_conditions")),
              _buildSettingItem(Icons.privacy_tip, AppLocalizations.of(context)!.translate("privacy_policy")),
              
              const SizedBox(height: 20),
              _buildSectionTitle(AppLocalizations.of(context)!.translate("app_info")),
              _buildSettingItem(Icons.info, AppLocalizations.of(context)!.translate("app_version")),
            ],
          ),
        ),
      ),
    );
  }

  // Language Preference Setting with Dropdown Dialog
  Widget _buildLanguagePreferenceItem() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.language, color: Colors.black),
        title: Text(AppLocalizations.of(context)!.translate("language")),
        onTap: () => _showLanguageDialog(),
      ),
    );
  }

  // Show Language Selection Dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("select_language")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption("English", const Locale('en', '')),
              _languageOption("हिन्दी (Hindi)", const Locale('hi', '')),
              _languageOption("தமிழ் (Tamil)", const Locale('ta', '')),
              _languageOption("ગુજરાતી (Gujarati)", const Locale('gu', '')),
            ],
          ),
        );
      },
    );
  }

  // Create Language Option
  Widget _languageOption(String language, Locale locale) {
    return ListTile(
      title: Text(language),
      onTap: () {
        _updateLanguage(locale.languageCode);
        Navigator.pop(context); // Close Dialog
      },
    );
  }

  // Widget for Section Titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget for Individual Settings Items
  Widget _buildSettingItem(IconData icon, String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        onTap: () {
          // Handle setting option click
        },
      ),
    );
  }
}
*/
