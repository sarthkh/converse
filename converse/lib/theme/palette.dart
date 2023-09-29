import 'package:flutter/material.dart';

class Palette {
  // colors
  static const Color lightRed = Color.fromARGB(255, 240, 128, 128);
  static const Color darkRed = Color.fromARGB(255, 207, 82, 78);
  static const Color lightWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color darkWhite = Color.fromARGB(255, 235, 235, 235);
  static const Color lightGrey = Color.fromARGB(255, 168, 169, 173);
  static const Color darkGrey = Color.fromARGB(255, 105, 105, 105);
  static const Color lightBlack = Color.fromARGB(255, 22, 22, 24);
  static const Color darkBlack = Color.fromARGB(255, 2, 4, 3);
  static const Color darkDrawer = Color.fromARGB(255, 0, 0, 0);
  static const Color lightDrawer = Color.fromARGB(255, 230, 230, 230);
  static const Color lightBlue = Color.fromARGB(255, 176, 196, 222);
  static const Color darkBlue = Color.fromARGB(255, 8, 37, 103);

  // dark theme
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: lightBlack,
    cardColor: darkGrey,
    hintColor: darkWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBlack,
      elevation: 0,
      iconTheme: IconThemeData(
        color: darkWhite,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: darkDrawer,
    ),
    primaryColor: darkRed,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: lightBlack,
      onPrimary: darkWhite,
      secondary: darkGrey,
      onSecondary: darkWhite,
      error: Colors.red,
      onError: darkWhite,
      background: lightBlack,
      onBackground: darkWhite,
      surface: darkDrawer,
      onSurface: darkWhite,
    ),
    useMaterial3: true,
  );

  // light theme
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: lightWhite,
    cardColor: lightGrey,
    hintColor: darkGrey,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightWhite,
      elevation: 0,
      iconTheme: IconThemeData(
        color: darkBlack,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: lightDrawer,
    ),
    primaryColor: lightRed,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: darkBlack,
      onPrimary: lightWhite,
      secondary: lightGrey,
      onSecondary: darkBlack,
      error: Colors.red,
      onError: lightWhite,
      background: lightWhite,
      onBackground: darkBlack,
      surface: lightDrawer,
      onSurface: darkBlack,
    ),
    useMaterial3: true,
  );
}
