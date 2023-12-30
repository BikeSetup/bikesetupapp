import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xff2e8bc1),
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardTheme(color: Colors.blueGrey[100]),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Color(0xff2e8bc1),
        iconTheme: IconThemeData(color: Colors.white)),
    cardColor: Colors.blueGrey[200], //Positioned Circles
    iconTheme: IconThemeData(color: Colors.grey[800]),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.grey[800], fontSize: 22),
      titleMedium: TextStyle(color: Colors.grey[800], fontSize: 20),
      titleSmall: TextStyle(color: Colors.grey[800], fontSize: 18),
      bodyLarge: TextStyle(color: Colors.grey[800], fontSize: 18),
      bodySmall: TextStyle(color: Colors.grey[800], fontSize: 16),
      bodyMedium: TextStyle(color: Colors.grey[800], fontSize: 14),
      labelLarge: TextStyle(color: Colors.grey[800], fontSize: 14),
      labelMedium: TextStyle(color: Colors.grey[800], fontSize: 12),
      labelSmall: TextStyle(color: Colors.grey[800], fontSize: 10),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xff2e8bc1),
    //primaryColor: Colors.red,
    scaffoldBackgroundColor: Colors.blueGrey[900],
    cardTheme: CardTheme(color: Colors.blueGrey[800]),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Color(0xff2e8bc1),
        iconTheme: IconThemeData(color: Colors.white)),
    cardColor: Colors.blueGrey[700], //Positioned Circles
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontSize: 22),
      titleMedium: TextStyle(color: Colors.white, fontSize: 20),
      titleSmall: TextStyle(color: Colors.white, fontSize: 18),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
      bodySmall: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      labelLarge: TextStyle(color: Colors.white, fontSize: 14),
      labelMedium: TextStyle(color: Colors.white, fontSize: 12),
      labelSmall: TextStyle(color: Colors.white, fontSize: 10),
    ),
  );
}
