import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromRGBO(30, 96, 137, 1);
  static const Color secondary = Colors.grey;

  static final ThemeData theme = ThemeData(
    colorSchemeSeed: primary,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headline5: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      subtitle1: TextStyle(
        fontSize: 14,
      ),
      caption: TextStyle(
        color: secondary,
      ),
    ),
    iconTheme: const IconThemeData(
      color: primary,
    ),
  );
}
