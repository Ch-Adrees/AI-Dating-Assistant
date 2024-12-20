import 'package:flutter/material.dart';

class ThemeOfApp {
  ThemeOfApp();

  static ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1B1B29),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1B1B29)),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      )),
    )),
    primaryColor: Colors.blue,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.white70,
      )),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.white,
      )),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.white,
      ),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: "Poppins",
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontFamily: "Poppins",
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
