import 'package:chatapp/themes/dark_mode.dart';
import 'package:chatapp/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  bool isClicked = false;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme(bool check) {
    if (check == true) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
