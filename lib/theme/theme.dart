import 'package:flutter/material.dart';

class FlutterTodosTheme {
  static ThemeData get light {
    return ThemeData(
      primarySwatch: Colors.purple,
      // colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF13B9FF)),
      appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 117, 208, 247)),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 16, 46, 59)),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: const Color(0xFF13B9FF)),
    );
  }
}
