import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  String _langCode = 'en';
  bool _isInitialized = false;

  Locale get locale => _locale;
  String get langCode => _langCode;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(AppConstants.langKey);
    if (saved != null) {
      _langCode = saved;
      _locale = Locale(saved);
      _isInitialized = true;
    }
    // If no language saved, we'll show language picker
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    _langCode = langCode;
    _locale = Locale(langCode);
    _isInitialized = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.langKey, langCode);
    notifyListeners();
  }

  bool get needsLanguageSelection => !_isInitialized;
}
