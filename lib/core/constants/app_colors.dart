import 'package:flutter/material.dart';

class AppColors {
  // --- Backgrounds ---
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF242424);

  // --- Branding (Electric Green / Deep Emerald) ---
  static const Color primary = Color(0xFF00FF94); // Electric Neon Green
  static const Color primaryDark = Color(0xFF008F52); // Deep Emerald
  static const Color accent = Color(0xFF00E676);
  
  // --- Supporting ---
  static const Color secondary = Color(0xFFB0B0B0);
  static const Color error = Color(0xFFFF4B4B);
  static const Color glass = Color(0x33FFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);

  // --- Text ---
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFF525252);

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, background],
  );
}
