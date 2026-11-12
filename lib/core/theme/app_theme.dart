import 'package:flutter/material.dart';

const Color brandGreen = Color(0xFF176B5B);
const Color brandGold = Color(0xFFD6AE45);
const Color pageBackground = Color(0xFFF5F7F2);
const Color darkPageBackground = Color(0xFF121B18);
const Color darkCardBackground = Color(0xFF1A2823);

ThemeData get appTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: brandGreen,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: pageBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: brandGreen,
    foregroundColor: Colors.white,
    centerTitle: false,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
);

ThemeData get appDarkTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: brandGreen,
    brightness: Brightness.dark,
    surface: darkCardBackground,
  ),
  scaffoldBackgroundColor: darkPageBackground,
  cardColor: darkCardBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0D221C),
    foregroundColor: Colors.white,
    centerTitle: false,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: darkCardBackground,
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
);
