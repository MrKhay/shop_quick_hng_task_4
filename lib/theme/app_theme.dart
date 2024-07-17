import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 43, 104, 140),
    background: const Color.fromARGB(255, 255, 255, 255),
    surface: const Color.fromARGB(255, 255, 255, 255),
    error: const Color.fromARGB(255, 250, 0, 25),
  ),
  fontFamily: GoogleFonts.poppins().fontFamily,
  useMaterial3: true,
);
