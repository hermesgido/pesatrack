import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextThemes {
 static final darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.montserrat(
        color: const Color(0xFFE0E0E0),
        fontSize: 24,
        fontWeight: FontWeight.bold),
    headlineMedium: GoogleFonts.montserrat(
        color: const Color(0xFFE0E0E0),
        fontSize: 20,
        fontWeight: FontWeight.bold),
    headlineSmall: GoogleFonts.montserrat(
        color: const Color(0xFFE0E0E0),
        fontSize: 18,
        fontWeight: FontWeight.w600),
    bodyLarge:
        GoogleFonts.montserrat(color: const Color(0xFFE0E0E0), fontSize: 16),
    bodyMedium:
        GoogleFonts.montserrat(color: const Color(0xFFE0E0E0), fontSize: 14),
    bodySmall:
        GoogleFonts.montserrat(color: const Color(0xFFE0E0E0), fontSize: 12),
    labelLarge: GoogleFonts.montserrat(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  );
  // iconTheme: const IconThemeData(color: Color(0xFF6D53F4)),

  static final lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.montserrat(
        color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium: GoogleFonts.montserrat(
        color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
    headlineSmall: GoogleFonts.montserrat(
        color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.montserrat(color: Colors.black87, fontSize: 16),
    bodyMedium: GoogleFonts.montserrat(color: Colors.black87, fontSize: 14),
    bodySmall: GoogleFonts.montserrat(color: Colors.black87, fontSize: 12),
    labelLarge: GoogleFonts.montserrat(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  );
}
