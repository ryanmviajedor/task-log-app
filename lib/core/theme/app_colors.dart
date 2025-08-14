import 'package:flutter/material.dart';

class AppColors {
  // Primary gradient colors
  static const Color primary1 = Color(0xFF4300FF); // Deep Purple
  static const Color primary2 = Color(0xFF0065F8); // Blue
  static const Color primary3 = Color(0xFF00CAFF); // Cyan
  static const Color primary4 = Color(0xFF00FFDE); // Mint

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary1, primary2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [primary2, primary3],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primary3, primary4],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fullGradient = LinearGradient(
    colors: [primary1, primary2, primary3, primary4],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  // Card gradients
  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0xFF4300FF),
      Color(0xFF0065F8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightCardGradient = LinearGradient(
    colors: [
      Color(0x104300FF),
      Color(0x100065F8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Status colors with gradients
  static const LinearGradient todoGradient = LinearGradient(
    colors: [Color(0xFF9E9E9E), Color(0xFF757575)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient inProgressGradient = LinearGradient(
    colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient completedGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Priority colors with gradients
  static const LinearGradient lowPriorityGradient = LinearGradient(
    colors: [Color(0xFFFFEB3B), Color(0xFFFFC107)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient normalPriorityGradient = LinearGradient(
    colors: [primary2, primary3],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient highPriorityGradient = LinearGradient(
    colors: [Color(0xFFFF5722), Color(0xFFD32F2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFFF8F9FA),
      Color(0xFFE9ECEF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF1A1A1A),
      Color(0xFF2D2D2D),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Utility colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF424242);
}
