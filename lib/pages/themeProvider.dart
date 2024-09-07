import 'package:flutter/material.dart';

ThemeData theme1 = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color.fromRGBO(11, 20, 27, 1),
    primary: Colors.green.shade600,
    secondary: Color.fromARGB(255, 30, 30, 30),
    tertiary: Color.fromARGB(255, 240, 240, 240),
    onSecondary: Colors.white,
  ),
);

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = theme1;

  ThemeData get themeData => _themeData;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
