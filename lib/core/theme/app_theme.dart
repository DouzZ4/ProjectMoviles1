import 'package:flutter/material.dart';
import 'colors.dart'; // Importa tus colores

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // Habilitar Material 3
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        error: AppColors.accent, // Usa el acento para errores, por ejemplo
        brightness: Brightness.light,
      ),

      fontFamily: 'Poppins', // Define una fuente si la tienes configurada

      appBarTheme: const AppBarTheme(
        elevation: 0, // AppBar sin sombra por defecto
        backgroundColor: AppColors.background, // Fondo igual al scaffold
        foregroundColor: AppColors.textPrimary, // Color de íconos y texto
        centerTitle: true, // Centrar título por defecto (opcional)
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary, // Botón principal amarillo
          foregroundColor: AppColors.textPrimary, // Texto oscuro sobre amarillo
          minimumSize: const Size(double.infinity, 48), // Tamaño mínimo
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Bordes redondeados
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),

      // Define otros estilos de widgets aquí (TextTheme, InputDecorations, etc.)
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(color: AppColors.textSecondary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
        // ... otros estilos
      ).apply(
        fontFamily: 'Poppins',
        bodyColor: AppColors.textPrimary,
      ), // Aplica fuente y color por defecto
    );
  }

  // Opcional: Define un darkTheme similar si quieres modo oscuro
  // static ThemeData get darkTheme { ... }
}
