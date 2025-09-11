import 'package:flutter/material.dart';

class ColorPalette {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color error;
  final Color success;
  final Color background;
  final Color warning;

  const ColorPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.error,
    required this.success,
    required this.background,
    required this.warning,
  });

  factory ColorPalette.light() => const ColorPalette(
        primary: Color.fromARGB(255, 255, 255, 255), // Azul profundo como primario
        secondary: Color(0xFF1976D2), // Azul medio como secundario
        accent: Color(0xFF64B5F6),    // Azul claro como acento
        error: Color(0xFFD32F2F),     // Rojo error
        success: Color(0xFF388E3C),   // Verde éxito
        background: Color(0xFF2A4B3A),// Blanco
        warning: Color(0xFFFFA000),   //         
      );

  factory ColorPalette.dark() => const ColorPalette(
        primary: Color(0xFF5472D3),   // Azul profundo más claro para visibilidad
        secondary: Color(0xFF90CAF9), // Azul medio claro como secundario
        accent: Color(0xFF42A5F5),    // Azul claro como acento
        error: Color(0xFFEF5350),
        success: Color(0xFF66BB6A),
        background: Color(0xFF121212),
        warning: Color(0xFFFFB300),   
      );

  static ColorPalette of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light
        ? ColorPalette.light()
        : ColorPalette.dark();
  }
}

class AppColors {
  static const Color white70 = Colors.white70;
  static const Color black87 = Colors.black87;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
   static const Color textColor1 = Color(0xFF989acd);
  static const Color textColor2 = Color(0xFF878593);
  static const Color bigTextColor = Color(0xFF2e2e31);

  static const Color mainColor = Color(0xFF5d69b3);
  static const Color starColor = Color(0xFFe7bb4e);

  static const Color blue = Color(0xFF003677);
  static const Color yellow2Fubode = Color.fromARGB(255, 253, 222, 65);
  static const Color blue2Fubode = Color.fromARGB(255, 0, 54, 119);

  static const Color cardLeterBlue = Color(0xFF003677);

  static const Color gray = Color.fromARGB(243, 236, 232, 232);
  static const Color error = Color.fromARGB(243, 255, 217, 47);
  static const Color info = Color.fromARGB(243, 225, 237, 241);

  static const Color green = Color.fromARGB(255, 46, 231, 61);
  static const Color red = Color.fromRGBO(255, 0, 0, 1);
  static const Color backgroundShawow = Color.fromARGB(255, 56, 99, 76);
}

