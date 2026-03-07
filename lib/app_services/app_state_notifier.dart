import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateNotifier extends ChangeNotifier {
  late ThemeMode themeMode;

  AppStateNotifier(this.themeMode);

  Future<void> updateTheme(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', mode.name);
    themeMode = mode;
    notifyListeners();
  }

  static ThemeMode fromPrefs(SharedPreferences prefs) {
    final saved = prefs.getString('themeMode');
    if (saved == null) return ThemeMode.dark;
    return ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.dark,
    );
  }
}
