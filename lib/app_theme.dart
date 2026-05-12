import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';

class AppTheme {
  //TEMA CLARO
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );

  //TEMA OSCURO
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color.fromARGB(255, 43, 43, 43), 
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: primaryColor,
    ),
  );
}