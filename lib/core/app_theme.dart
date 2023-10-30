import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff5D9CEC),
      background: const Color(0xffDFECDB),
      secondary: Colors.white,
    ),
    primaryColor: const Color(0xff5D9CEC),
    textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        titleMedium: GoogleFonts.roboto(
          color: const Color(0xff5D9CEC),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        bodyLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xff5D9CEC)),
        bodyMedium: GoogleFonts.poppins(
          color: const Color(0xff5D9CEC),
          fontWeight: FontWeight.normal,
          fontSize: 15,
        ),
        bodySmall: GoogleFonts.poppins(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedIconTheme: IconThemeData(color: Color(0xffC8C9CB)),
      showUnselectedLabels: false,
      showSelectedLabels: false,
      selectedIconTheme: IconThemeData(color: Color(0xff5D9CEC)),
    ),
  );
  ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff5D9CEC),
      background: const Color(0xff060E1E),
      secondary: Colors.white,
    ),
    primaryColor: const Color(0xff5D9CEC),
    textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        titleMedium: GoogleFonts.roboto(
          color: const Color(0xff5D9CEC),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        bodyLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xff5D9CEC)),
        bodyMedium: GoogleFonts.poppins(
          color: const Color(0xff5D9CEC),
          fontWeight: FontWeight.normal,
          fontSize: 15,
        ),
        bodySmall: GoogleFonts.poppins(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedIconTheme: IconThemeData(color: Color(0xffC8C9CB)),
      showUnselectedLabels: false,
      showSelectedLabels: false,
      selectedIconTheme: IconThemeData(color: Color(0xff5D9CEC)),
    ),
  );
}
