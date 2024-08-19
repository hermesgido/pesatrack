// import 'package:flutter/material.dart';

// class AppThemes {
//   static final lightTheme = ThemeData(
//     primaryColor: const Color(0xFF6D53F4),
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: const Color(0xFFF3F3F3),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFFFFFFFF),
//       iconTheme: IconThemeData(color: Colors.black),
//     ),
//     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//       backgroundColor: Colors.white,
//       selectedItemColor: Color(0xFF6D53F4),
//       unselectedItemColor: Colors.grey,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.black87),
//       bodyMedium: TextStyle(color: Colors.black87),
//     ),
//     iconTheme: const IconThemeData(color: Color(0xFF6D53F4)),
//   );

//   static final darkTheme = ThemeData(
//     primaryColor: const Color(0xFF6D53F4),
//     colorScheme: const ColorScheme(
//       secondary: Color(0xFFEE600D),
//       brightness: Brightness.dark,
//       primary: Color(0xFF6D53F4),
//       onPrimary: Color(0xFFEE600D),
//       onSecondary: Color(0xFFEE600D),
//       error: Colors.red,
//       onError: Colors.red,
//       background: Color(0xFF1F1F1F),
//       onBackground: Colors.white,
//       surface: Color(0xFF1F1F1F),
//       onSurface: Colors.white,

//     ),
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: const Color(0xFF121212),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFF1F1F1F),
//       iconTheme: IconThemeData(color: Colors.white),
//     ),
//     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//       backgroundColor: Color(0xFF1F1F1F),
//       selectedItemColor: Color(0xFF6D53F4),
//       unselectedItemColor: Colors.grey,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.white),
//       bodyMedium: TextStyle(color: Colors.white),
//     ),
//     iconTheme: const IconThemeData(color: Color(0xFF6D53F4)),
//   );
// }
import 'package:flutter/material.dart';
import 'package:pesatrack/utils/text_theme.dart';

final textTheme = TextThemes();

class AppThemes {
  static final lightTheme = ThemeData(
    primaryColor: const Color(0xFF6D53F4),
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF3F3F3),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF6D53F4),
      unselectedItemColor: Colors.grey,
    ),
    textTheme: TextThemes.lightTextTheme,
    iconTheme: const IconThemeData(color: Color(0xFF6D53F4)),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF6D53F4),
    colorScheme: const ColorScheme(
      secondary: Color(0xFFEE600D),
      brightness: Brightness.dark,
      primary: Color(0xFF6D53F4),
      onPrimary: Color(0xFFEE600D),
      onSecondary: Color(0xFFEE600D),
      error: Colors.red,
      onError: Colors.red,
      background: Color(0xFF1F1F1F),
      onBackground: Colors.white,
      surface: Color(0xFF1F1F1F),
      onSurface: Colors.white,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1F1F1F),
      selectedItemColor: Color(0xFF6D53F4),
      unselectedItemColor: Colors.grey,
    ),
    textTheme: TextThemes.darkTextTheme,
  );
}
