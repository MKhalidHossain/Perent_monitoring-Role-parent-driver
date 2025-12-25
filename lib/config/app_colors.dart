import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF8A2BE2);
  static const Color primaryLight = Color(0xFFD8C1E8);
  static const Color primaryDark = Color(0xFF6A1B9A);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF4A90E2);
  static const Color secondaryLight = Color(0xFFB0C4DE);
  
  // Design-specific colors
  static const Color lightPurple = Color(0xFFE8D5F2);
  static const Color orange = Color(0xFFFF8C00);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF666666);
  static const Color green = Color(0xFF4CAF50);
  static const Color yellow = Color(0xFFFFD700);
  static const Color red = Color(0xFFF44336);
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundGradientStart = Color(0xFFE0E6F0);
  static const Color backgroundGradientEnd = Color(0xFFC0C8D8);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Accent Colors
  static const Color accent = Color(0xFFFFD700);
  static const Color accentLight = Color(0xFFFFF8DC);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Input Colors
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBorder = Color(0xFFE0E0E0);
  
  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);
  
  // Button Colors
  static const Color buttonPrimary = Color(0xFF8A2BE2);
  static const Color buttonSecondary = Color(0xFF4A90E2);
  static const Color buttonDisabled = Color(0xFFCCCCCC);
  
  // Gradient Button Colors
  static const Color gradientButtonStart = Color(0xFFE9CCE2);
  static const Color gradientButtonEnd = Color(0xFF909EDB);
  
  // Gradient for buttons
  static const LinearGradient gradientButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gradientButtonStart, gradientButtonEnd],
  );
  
  // Icon Colors
  static const Color iconPrimary = Color(0xFF000000);
  static const Color iconSecondary = Color(0xFF666666);
  static const Color iconLight = Color(0xFF999999);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFD0B0E8), Color(0xFFA0B0E0)],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE0E6F0), Color(0xFFC0C8D8)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFD0B0E8), Color(0xFFA0B0E0)],
  );

  static const Color driverDashboardCardBackground = Color(0xFFF4F4F4);
}
