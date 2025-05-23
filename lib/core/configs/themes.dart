import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.amber,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 9,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      inputDecoratorRadius: 8.0,
      cardRadius: 12.0,
      bottomNavigationBarElevation: 0,
      bottomNavigationBarOpacity: 1.0,
    ),
    textTheme: _textTheme,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );

  static final ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.amber,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 15,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      inputDecoratorRadius: 8.0,
      cardRadius: 12.0,
      bottomNavigationBarElevation: 0,
      bottomNavigationBarOpacity: 1.0,
    ),
    textTheme: _textTheme,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );

  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.nunito(fontWeight: FontWeight.w700),
    displayMedium: GoogleFonts.nunito(fontWeight: FontWeight.w700),
    displaySmall: GoogleFonts.nunito(fontWeight: FontWeight.w700),
    headlineLarge: GoogleFonts.nunito(fontWeight: FontWeight.w700),
    headlineMedium: GoogleFonts.nunito(fontWeight: FontWeight.w700),
    headlineSmall: GoogleFonts.nunito(fontWeight: FontWeight.w700),
    titleLarge: GoogleFonts.nunito(fontWeight: FontWeight.w700),
    titleMedium: GoogleFonts.nunito(fontWeight: FontWeight.w600),
    titleSmall: GoogleFonts.nunito(fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.nunito(),
    bodyMedium: GoogleFonts.nunito(),
    bodySmall: GoogleFonts.nunito(),
    labelLarge: GoogleFonts.nunito(fontWeight: FontWeight.w600),
    labelMedium: GoogleFonts.nunito(fontWeight: FontWeight.w600),
    labelSmall: GoogleFonts.nunito(fontWeight: FontWeight.w600),
  );
}