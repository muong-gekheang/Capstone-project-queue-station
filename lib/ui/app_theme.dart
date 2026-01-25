import 'package:flutter/material.dart';

class AppTheme {
  // 1. Define the Hex Colors
  static const Color primaryColor = Color(0xFFFF6835);
  static const Color secondaryColor = Color(0x000D47A1);
  static const Color accentRed = Color(0xFFB22222);
  static const Color accentYellow = Color(0xFFFFBF00);
  static const Color naturalBlack = Color(0xFF000000);
  static const Color naturalWhite = Color(0xFFFFFFFF);
  static const Color naturalGrey = Color(0xFFD4D8D6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Scaffold Background
      scaffoldBackgroundColor: naturalWhite,

      // Defining the ColorScheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        onPrimary: naturalWhite,
        onSecondary: naturalWhite,
        surface: naturalWhite,
        onSurface: naturalBlack,
      ),

      // Adding Custom Accents via ThemeExtension
      extensions: [
        CustomColors(accentRed: accentRed, accentYellow: accentYellow),
      ],
    );
  }
}

// 2. Create an Extension for custom colors not in the standard ColorScheme
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? accentRed;
  final Color? accentYellow;

  const CustomColors({required this.accentRed, required this.accentYellow});

  @override
  CustomColors copyWith({Color? accentRed, Color? accentYellow}) {
    return CustomColors(
      accentRed: accentRed ?? this.accentRed,
      accentYellow: accentYellow ?? this.accentYellow,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      accentRed: Color.lerp(accentRed, other.accentRed, t),
      accentYellow: Color.lerp(accentYellow, other.accentYellow, t),
    );
  }
}
