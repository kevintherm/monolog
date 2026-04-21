import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MonoColors {
  MonoColors._();

  static const Color amber = Color(0xFFD4A017);
  static const Color amberLight = Color(0xFFE8C547);
  static const Color amberDark = Color(0xFF9B7510);
  static const Color gold = Color(0xFFF5CE42);
  static const Color honey = Color(0xFFFFF3C4);

  static const Color bg = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF242424);
  static const Color surfaceHigh = Color(0xFF2E2E2E);
  static const Color card = Color(0xFF2A2A2A);

  static const Color textPrimary = Color(0xFFF5F0E1);
  static const Color textSecondary = Color(0xFFB0A88E);
  static const Color textMuted = Color(0xFF706B5A);

  static const Color danger = Color(0xFFE85D4A);
  static const Color success = Color(0xFF5CB85C);
  static const Color info = Color(0xFF5AA8D5);

  static const Color border = Color(0xFF3A3A3A);
  static const Color borderStrong = Color(0xFFD4A017);
}

class MonoSpacing {
  MonoSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double huge = 64;
}

class MonoText {
  MonoText._();

  static TextStyle _base({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = MonoColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle displayLg = _base(size: 36, weight: FontWeight.w800, letterSpacing: -1.5);
  static TextStyle display = _base(size: 28, weight: FontWeight.w800, letterSpacing: -1);

  static TextStyle h1 = _base(size: 24, weight: FontWeight.w700, letterSpacing: -0.5);
  static TextStyle h2 = _base(size: 20, weight: FontWeight.w700);
  static TextStyle h3 = _base(size: 17, weight: FontWeight.w600);

  static TextStyle bodyLg = _base(size: 16, weight: FontWeight.w400, height: 1.5);
  static TextStyle body = _base(size: 14, weight: FontWeight.w400, height: 1.5);
  static TextStyle bodySm = _base(size: 12, weight: FontWeight.w400, height: 1.4);

  static TextStyle labelLg = _base(size: 16, weight: FontWeight.w700, letterSpacing: 1.5);
  static TextStyle label = _base(size: 13, weight: FontWeight.w700, letterSpacing: 1.2);
  static TextStyle labelSm = _base(size: 11, weight: FontWeight.w700, letterSpacing: 1);

  static TextStyle number = GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: MonoColors.textPrimary,
  );
  static TextStyle numberSm = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: MonoColors.textPrimary,
  );
}

class MonoDecor {
  MonoDecor._();

  static const double borderWidth = 3;
  static const double shadowOffset = 4;

  static BoxDecoration card({Color? color, Color? borderColor}) {
    return BoxDecoration(
      color: color ?? MonoColors.card,
      border: Border.all(
        color: borderColor ?? MonoColors.border,
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: (borderColor ?? MonoColors.border).withValues(alpha: 0.5),
          offset: const Offset(shadowOffset, shadowOffset),
          blurRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration cardAccent({Color? color}) {
    return card(
      color: color ?? MonoColors.surface,
      borderColor: MonoColors.amber,
    );
  }

  static BoxDecoration input({bool focused = false}) {
    return BoxDecoration(
      color: MonoColors.surfaceHigh,
      border: Border.all(
        color: focused ? MonoColors.amber : MonoColors.border,
        width: 2,
      ),
    );
  }

  static BoxDecoration tile(Color color) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: Colors.black, width: borderWidth),
      boxShadow: const [
        BoxShadow(
          color: Colors.black54,
          offset: Offset(shadowOffset, shadowOffset),
          blurRadius: 0,
        ),
      ],
    );
  }

  static const EdgeInsets cardPadding = EdgeInsets.all(MonoSpacing.base);
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: MonoSpacing.lg,
    vertical: MonoSpacing.base,
  );
}

class Gap {
  Gap._();

  static const SizedBox xs = SizedBox(height: MonoSpacing.xs);
  static const SizedBox sm = SizedBox(height: MonoSpacing.sm);
  static const SizedBox md = SizedBox(height: MonoSpacing.md);
  static const SizedBox base = SizedBox(height: MonoSpacing.base);
  static const SizedBox lg = SizedBox(height: MonoSpacing.lg);
  static const SizedBox xl = SizedBox(height: MonoSpacing.xl);
  static const SizedBox xxl = SizedBox(height: MonoSpacing.xxl);
  static const SizedBox xxxl = SizedBox(height: MonoSpacing.xxxl);

  static const SizedBox hXs = SizedBox(width: MonoSpacing.xs);
  static const SizedBox hSm = SizedBox(width: MonoSpacing.sm);
  static const SizedBox hMd = SizedBox(width: MonoSpacing.md);
  static const SizedBox hBase = SizedBox(width: MonoSpacing.base);
  static const SizedBox hLg = SizedBox(width: MonoSpacing.lg);
  static const SizedBox hXl = SizedBox(width: MonoSpacing.xl);
}

ThemeData buildMonoLogTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: MonoColors.bg,
    primaryColor: MonoColors.amber,
    colorScheme: const ColorScheme.dark(
      primary: MonoColors.amber,
      secondary: MonoColors.gold,
      surface: MonoColors.surface,
      error: MonoColors.danger,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: MonoColors.textPrimary,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: MonoColors.bg,
      elevation: 0,
      titleTextStyle: MonoText.h2.copyWith(color: MonoColors.amber),
      iconTheme: const IconThemeData(color: MonoColors.amber),
    ),
    textTheme: TextTheme(
      headlineLarge: MonoText.h1,
      headlineMedium: MonoText.h2,
      headlineSmall: MonoText.h3,
      bodyLarge: MonoText.bodyLg,
      bodyMedium: MonoText.body,
      bodySmall: MonoText.bodySm,
      labelLarge: MonoText.labelLg,
      labelMedium: MonoText.label,
      labelSmall: MonoText.labelSm,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MonoColors.surfaceHigh,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: MonoColors.border, width: 2),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: MonoColors.border, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: MonoColors.amber, width: 2),
      ),
      labelStyle: MonoText.label.copyWith(color: MonoColors.textSecondary),
      hintStyle: MonoText.body.copyWith(color: MonoColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MonoSpacing.base,
        vertical: MonoSpacing.md,
      ),
    ),
    dividerColor: MonoColors.border,
    dividerTheme: const DividerThemeData(
      color: MonoColors.border,
      thickness: 2,
    ),
  );
}
