import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF64B5F6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color alertColor = Color(0xFFE57373);
  static const Color darkAlertColor = Color(0xFFB75D5D);

  static const Color temperaturaAltaColor = Color(0xFFF44336);
  static const Color temperaturaBajaColor = Color(0xFF42A5F5);
  static const Color vientoColor = Color(0xFF78909C);
  static const Color humedadColor = Color(0xFF29B6F6);

  static const Color textColorPrimary = Color(0xFF212121);
  static const Color textColorSecondary = Color(0xFF757575);
  static const Color textColorLight = Color(0xFFFFFFFF);

  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColorPrimary = Color(0xFFEEEEEE);
  static const Color darkTextColorSecondary = Color(0xFFB0B0B0);

  static const int alertBgAlphaLight = 100;
  static const int alertBgAlphaDark = 100;
  static const Color alertButtonDark = Color(0xFFDB5A5A);

  static ThemeData modoClaro() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: textColorLight,
        secondary: secondaryColor,
        onSecondary: textColorPrimary,
        error: alertColor,
        onError: textColorLight,
        surface: cardColor,
        onSurface: textColorPrimary,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textColorLight,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColorLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textColorPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textColorPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: textColorPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textColorPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textColorSecondary, fontSize: 14),
      ),
    );
  }

  static ThemeData modoOscuro() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primaryColor,
        onPrimary: textColorLight,
        secondary: secondaryColor,
        onSecondary: darkTextColorPrimary,
        error: darkAlertColor,
        onError: textColorLight,
        surface: Color(0xFF232A34),
        onSurface: darkTextColorPrimary,
      ),
      scaffoldBackgroundColor: Color(0xFF181C22),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF102840),
        foregroundColor: textColorLight,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Color(0xFF232A34),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColorLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF232A34),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: darkTextColorPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: darkTextColorPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: darkTextColorPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: darkTextColorPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: darkTextColorSecondary, fontSize: 14),
      ),
    );
  }
}
