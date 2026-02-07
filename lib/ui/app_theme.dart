import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 1. Define the Hex Colors
  static const Color primaryColor = Color(0xFFFF6835);
  static const Color secondaryColor = Color(0xFF0D47A1);
  static const Color accentRed = Color(0xFFB22222);
  static const Color accentYellow = Color(0xFFFFBF00);
  static const Color naturalBlack = Color(0xFF000000);
  static const Color naturalWhite = Color(0xFFFFFFFF);
  static const Color naturalGrey = Color(0xFFD4D8D6);
  static const Color naturalTextGrey = Color(0xFF6C6C6C);

  // 2. Define Font Sizes
  static const double displayText = 48.0;
  static const double displayText2 = 36.0;
  static const double heading1 = 24.0;
  static const double heading2 = 20.0;
  static const double heading3 = 18.0;
  static const double bodyText = 16.0;
  static const double smallText = 14.0;
  static const double tinyText1 = 12.0;
  static const double tinyText2 = 10.0;

  // 3. Define Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border
  static const double borderRadiusS = 8.0;
  static const double borderRadiusM = 12.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXl = 30.0;


  // Icon Sizes
  static const double iconSizeXl = 32.0;
  static const double iconSizeL = 26.0;
  static const double iconSizeM = 18.0;
  static const double iconSizeS = 14.0;

  // elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;

  // Image sizes
  static const double restaurantImage1 = 160;
  static const double restaurantImage2 = 75.0;
  static const double userProfileImage = 125;
  static const double logoImage = 120.0;
  static const double menuImage1 = 175.0;
  static const double menuImage2 = 160.0;
  static const double menuImage3 = 100.0;
  static const double menuImage4 = 50.0;
  static const double menuImage5 = 35.0;  

  // 4. ThemeData with Inter as default font
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Scaffold & AppBar
      scaffoldBackgroundColor: naturalWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: naturalWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),

      // Colors
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        onPrimary: naturalWhite,
        onSecondary: naturalWhite,
        surface: naturalWhite,
        onSurface: naturalBlack,
      ),

      // Custom colors
      extensions: [
        CustomColors(accentRed: accentRed, accentYellow: accentYellow),
      ],

      // 5. TextTheme with Inter
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: heading1,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontSize: heading2,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            fontSize: heading3,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(fontSize: bodyText),
          bodyMedium: TextStyle(fontSize: smallText),
        ),
      ),
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
