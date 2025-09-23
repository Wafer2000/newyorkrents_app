import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// El tema web usa Assistant (header/body) con peso 400.
/// Si el tema cambia, ajusta aquí o usa GoogleFonts.getFont(nombre).
class AppTypography {
  static TextTheme lightText() {
    final base = GoogleFonts.assistantTextTheme(
      const TextTheme(),
    );
    return base.copyWith(
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 16),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 14),
      bodySmall: base.bodySmall?.copyWith(fontSize: 12),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  static TextTheme darkText() {
    final base = GoogleFonts.assistantTextTheme(
      const TextTheme(),
    );
    return base.copyWith(
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 16),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 14),
      bodySmall: base.bodySmall?.copyWith(fontSize: 12),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }
}
