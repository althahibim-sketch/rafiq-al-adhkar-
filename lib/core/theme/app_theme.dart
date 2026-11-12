import 'package:flutter/material.dart';

const Color brandGreen = Color(0xFF176B5B);
const Color brandGold = Color(0xFFD6AE45);
const Color pageBackground = Color(0xFFF5F7F2);

ThemeData get appTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: brandGreen),
  scaffoldBackgroundColor: pageBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: brandGreen,
    foregroundColor: Colors.white,
    centerTitle: false,
  ),
);
