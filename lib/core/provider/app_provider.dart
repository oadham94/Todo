import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode curTheme = ThemeMode.dark;
  SharedPreferences? prefs;
  final String _key = "Theme";

  changeTheme(ThemeMode newTheme) {
    if (curTheme == newTheme) return;
    curTheme = newTheme;
    notifyListeners();
    saveThemeData(newTheme);
  }

  getThemeData() {
    return prefs!.getString(_key);
  }

  Future<void> saveThemeData(ThemeMode themeMode) async {
    String themeValue = (themeMode == ThemeMode.light) ? "light" : "dark";
    await prefs!.setString(_key, themeValue);
  }

  Future<void> loadData() async {
    prefs = await SharedPreferences.getInstance();
    String? themeMode = getThemeData();
    if (themeMode != null) {
      curTheme = themeMode == "light" ? ThemeMode.light : ThemeMode.dark;
    }
  }
}
