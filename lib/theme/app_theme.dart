import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales
  static const Color primaryColor = Color(0xFF2196F3); // Azul principal
  static const Color secondaryColor = Color(0xFF64B5F6); // Azul secundario
  static const Color accentColor = Color(0xFFFFA726); // Naranja para acentos
  static const Color backgroundColor = Color(0xFFF5F5F5); // Fondo claro
  static const Color cardColor = Color(0xFFFFFFFF); // Tarjetas blancas
  static const Color errorColor = Color(0xFFE57373); // Rojo para errores

  // Colores para el clima
  static const Color tempHotColor = Color(
    0xFFF44336,
  ); // Rojo para temperaturas altas
  static const Color tempColdColor = Color(
    0xFF42A5F5,
  ); // Azul para temperaturas bajas
  static const Color rainColor = Color(0xFF42A5F5); // Azul para lluvia
  static const Color sunnyColor = Color(0xFFFFEB3B); // Amarillo para soleado
  static const Color cloudyColor = Color(0xFF90A4AE); // Gris para nublado
  static const Color windColor = Color(0xFF78909C); // Azul grisáceo para viento
  static const Color humidityColor = Color(
    0xFF29B6F6,
  ); // Azul claro para humedad

  // Textos
  static const Color textColorPrimary = Color(
    0xFF212121,
  ); // Negro para texto principal
  static const Color textColorSecondary = Color(
    0xFF757575,
  ); // Gris para texto secundario
  static const Color textColorLight = Color(
    0xFFFFFFFF,
  ); // Blanco para texto sobre fondos oscuros

  // Tema para Material 3
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        error: errorColor,
        brightness: Brightness.light,
      ),

      // Configuración general
      scaffoldBackgroundColor: backgroundColor,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textColorLight,
        elevation: 0,
      ),

      // Tarjetas
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColorLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Campos de texto
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

      // Textos
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
}
