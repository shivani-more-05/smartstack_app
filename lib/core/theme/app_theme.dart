import 'package:flutter/material.dart';

const Color lavenderMist = Color(0xFFECE6F6);
const Color deepLilac = Color(0xFF8C6EC7);

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: lavenderMist,
    primaryColor: deepLilac,
    colorScheme: ColorScheme.fromSeed(
      seedColor: deepLilac,
      primary: deepLilac,
      secondary: deepLilac,
      background: lavenderMist,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: deepLilac,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
