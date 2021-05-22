import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final ThemeData theme = ThemeData(
    textTheme: TextTheme(
      headline1: GoogleFonts.lexendDeca(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headline3: GoogleFonts.lexendDeca(
        color: Colors.black,
        fontSize: 10.0,
      ),
      headline4: GoogleFonts.lexendDeca(
        color: Colors.black,
        fontSize: 14.0,
      ),
      headline5: GoogleFonts.lexendDeca(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
      headline6: GoogleFonts.lexendDeca(
        color: Colors.black,
        fontSize: 12.0,
      ),
    ),
  );
}
