import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTheme {
  static const lightThemeFont = "ComicNeue", darkThemeFont = "Poppins";

  // light theme
  static final lightTheme = ThemeData(
    primaryColor: primaryLightColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: secondColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryLightColor,
      selectedItemColor: primaryLightColor,
      unselectedItemColor: secondColor,
      selectedIconTheme: IconThemeData(color: primaryLightColor),
      unselectedIconTheme: IconThemeData(color: secondColor),
    ),
    useMaterial3: true,
    secondaryHeaderColor: secondColor,
    textTheme: TextTheme(
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primaryLightColor,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryLightColor,
      ),
      titleLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: primaryLightColor),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primaryLightColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w900,
        color: primaryLightColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primaryLightColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryLightColor,
      ),
      displayMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, color: primaryLightColor),
      displayLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: primaryLightColor),
    ),
    primaryTextTheme: TextTheme(
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primaryLightColor,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryLightColor,
      ),
      titleLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: primaryLightColor),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.yellow,
      accentColor: secondColor,
      brightness: Brightness.light,
    ).copyWith(
      secondary: secondColor,
      primary: primaryLightColor,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryLightColor,
      textTheme: ButtonTextTheme.primary,
    ),
    fontFamily: lightThemeFont,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryLightColor,
    ),
    primaryColorLight: primaryLightColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: primaryLightColor,
      scrolledUnderElevation: 1,
     
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: white,
        fontSize: 23, //20
      ),
      iconTheme: IconThemeData(color: primaryLightColor),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: primaryLightColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );

  // dark theme
  static final darkTheme = ThemeData(
    primaryColor: darkThemeColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: black,
    useMaterial3: true,
    fontFamily: darkThemeFont,
    switchTheme: SwitchThemeData(
      trackColor:
          MaterialStateProperty.resolveWith<Color>((states) => darkThemeColor),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: black,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: white,
        fontSize: 23, //20
      ),
      iconTheme: IconThemeData(color: darkThemeColor),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: darkThemeColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: black,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
  );

  // colors
  static Color primaryLightColor = const Color(0xFF232B59),
      secondColor = const Color(0xFFF2B807),
      white = Colors.white,
      black = Colors.black,
      darkThemeColor = Colors.yellow;
}
