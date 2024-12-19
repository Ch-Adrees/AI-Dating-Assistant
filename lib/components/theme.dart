import 'package:flutter/material.dart';

class ThemeOfApp {
  ThemeOfApp();

  static ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      )),
    )),
    primaryColor: Colors.blue,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2.0),
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
