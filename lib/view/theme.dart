import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpsiTheme {
  UpsiTheme._(); // Private constructor to prevent instantiation

  static const primaryColor = Color(0xFFFFB967);
  static const secondaryColor = Color(0xFFFF7979);
  static const backgroundGradientStartColor = Color(0xFFFFF1E3);
  static const backgroundGradientEndColor = Color(0xFFFFDDE9);
  static const splashColor = Color(0xFFE4E3E6);
  static const blackColor = Colors.black;
  static const whiteColor = Colors.white;
  static const transparent = Colors.transparent;

  static const sfProDisplay = "SFProDisplay";
  static const sfProText = "SFProText";

  static Size size = PlatformDispatcher.instance.views.first.physicalSize;
  static double ratio = PlatformDispatcher.instance.views.first.devicePixelRatio;
  static double width = size.width / ratio;
  static double height = size.height / ratio;

  static ThemeData light = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: sfProText,

    colorScheme: ColorScheme.fromSeed(
      seedColor: secondaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: primaryColor,
        fontFamily: sfProDisplay,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: secondaryColor,
        fontFamily: sfProDisplay,
        fontWeight: FontWeight.w600,
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

    appBarTheme: const AppBarTheme(
      foregroundColor: primaryColor,
      backgroundColor: transparent,
      elevation: 0,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      surfaceTintColor: whiteColor,
      elevation: 5,
      shadowColor: blackColor,

      // showDragHandle: true,

      constraints: BoxConstraints(
        maxWidth: width - 32,
      ),
    ),
  );

  static BoxDecoration homeBackground = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [backgroundGradientStartColor, backgroundGradientEndColor],
    )
  );

  static SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: transparent,
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light, // For iOS (dark icons)
  );
}

