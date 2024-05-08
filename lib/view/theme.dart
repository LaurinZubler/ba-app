import 'package:flutter/material.dart';

class UpsiTheme {
  UpsiTheme._(); // Private constructor to prevent instantiation

  static const primaryColor = Color(0xFFFFB967);
  static const secondaryColor = Color(0xFFFF7979);
  static const backgroundGradientStartColor = Color(0xFFFFF1E3);
  static const backgroundGradientEndColor = Color(0xFFFFDDE9);
  static const splashColor = Color(0xFFE4E3E6);
  static const blackColor = Colors.black;
  static const whiteColor = Colors.white;

  static ThemeData light = ThemeData(
    useMaterial3: true,

    visualDensity: VisualDensity.adaptivePlatformDensity,

    colorScheme: ColorScheme.fromSeed(
      seedColor: secondaryColor,
      primary: primaryColor,
      secondary: secondaryColor
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: primaryColor,
      ),

      titleLarge: TextStyle(
        color: secondaryColor,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: whiteColor,
      foregroundColor: primaryColor,
      splashColor: splashColor,
    ),

    cardTheme: const CardTheme(
      elevation: 5,
      color: whiteColor,
      surfaceTintColor: whiteColor,
    ),
  );

  static BoxDecoration homeBackground = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [backgroundGradientStartColor, backgroundGradientEndColor],
    )
  );
}

