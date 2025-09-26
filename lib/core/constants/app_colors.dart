import 'package:flutter/material.dart';

class AppColors {
  // Primary colors from the design
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color secondary = Color(0xFF74B9FF);

  // Background colors
  static const Color background = Color(0xFF1E1E2E);
  static const Color backgroundLight = Color(0xFF2A2A3A);
  static const Color surface = Color(0xFF3A3A4A);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF808080);

  // Accent colors
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFE17055);
  static const Color error = Color(0xFFE74C3C);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, backgroundLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Card and container colors
  static const Color cardBackground = Color(0xFF2D2D3D);
  static const Color divider = Color(0xFF404040);

  // Button colors
  static const Color buttonEnabled = primary;
  static const Color buttonDisabled = Color(0xFF555555);

  // Switch and toggle colors
  static const Color switchActive = primary;
  static const Color switchInactive = Color(0xFF666666);
}
