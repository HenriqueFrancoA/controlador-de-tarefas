import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'color_schemes.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightColorScheme,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: _lightColorScheme.onPrimary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _lightColorScheme.onPrimary,
    foregroundColor: _lightColorScheme.onPrimary,
  ),
  dialogBackgroundColor: _lightColorScheme.onPrimary,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 18,
    ),
    bodyMedium: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 16,
    ),
    bodySmall: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 14,
    ),
    titleLarge: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.roboto(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: GoogleFonts.roboto(
      color: const Color(0xFF333333),
      fontSize: 18,
    ),
    labelMedium: GoogleFonts.roboto(
      color: const Color(0xFF333333),
      fontSize: 16,
    ),
    labelSmall: GoogleFonts.roboto(
      color: const Color(0xFF333333),
      fontSize: 14,
    ),
    displayLarge: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _darkColorScheme,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: _darkColorScheme.onPrimary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _darkColorScheme.onPrimary,
    foregroundColor: _darkColorScheme.onPrimary,
  ),
  dialogBackgroundColor: _darkColorScheme.onPrimary,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 18,
    ),
    bodyMedium: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 16,
    ),
    bodySmall: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 14,
    ),
    titleLarge: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 18,
    ),
    labelMedium: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 16,
    ),
    labelSmall: GoogleFonts.roboto(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 14,
    ),
    displayLarge: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.roboto(
      color: Colors.red,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
);
