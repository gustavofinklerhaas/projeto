import 'package:flutter/material.dart';

/// Tema da aplicação com foco em acessibilidade
class AppTheme {
  static const double minTouchSize = 48.0;

  // ===== LIGHT MODE COLORS =====
  // Cores com contraste adequado (WCAG AA)
  static const Color primaryColor = Color(0xFF2E7D32); // Verde
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF66BB6A);
  static const Color accentColor = Color(0xFFFFA726); // Laranja
  static const Color errorColor = Color(0xFFD32F2F); // Vermelho
  static const Color warningColor = Color(0xFFF57C00); // Laranja escuro
  static const Color successColor = Color(0xFF388E3C); // Verde escuro

  // Cores neutras - Light Mode
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF212121);
  static const Color darkGrey = Color(0xFF424242);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color veryLightGrey = Color(0xFFFAFAFA);

  // Background - Light Mode
  static const Color background = veryLightGrey;
  static const Color surface = white;

  // Text colors with high contrast - Light Mode
  static const Color textPrimary = black;
  static const Color textSecondary = grey;
  static const Color textDisabled = Color(0xFFBDBDBD);

  // ===== DARK MODE COLORS =====
  // Cores para dark mode
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);
  
  // Text colors - Dark Mode
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkTextDisabled = Color(0xFF616161);

  // Primary colors adjusted for dark mode
  static const Color darkPrimaryColor = Color(0xFF66BB6A);
  static const Color darkPrimaryLight = Color(0xFF81C784);
  static const Color darkAccentColor = Color(0xFFFFB74D);

  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        surface: surface,
        onPrimary: white,
        onSecondary: black,
        onError: white,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _titleLargeStyle.copyWith(color: white),
      ),
      textTheme: TextTheme(
        displayLarge: _displayLargeStyle,
        displayMedium: _displayMediumStyle,
        displaySmall: _displaySmallStyle,
        headlineMedium: _headlineMediumStyle,
        headlineSmall: _headlineSmallStyle,
        titleLarge: _titleLargeStyle,
        titleMedium: _titleMediumStyle,
        titleSmall: _titleSmallStyle,
        bodyLarge: _bodyLargeStyle,
        bodyMedium: _bodyMediumStyle,
        bodySmall: _bodySmallStyle,
        labelLarge: _labelLargeStyle,
        labelMedium: _labelMediumStyle,
        labelSmall: _labelSmallStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: white,
          minimumSize: const Size(minTouchSize, minTouchSize),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: _labelLargeStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
        ),
      ),
      iconTheme: const IconThemeData(
        size: minTouchSize,
        color: textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        fillColor: veryLightGrey,
        filled: true,
        hintStyle: _bodyMediumStyle.copyWith(color: textSecondary),
        labelStyle: _bodyMediumStyle,
        errorStyle: _bodySmallStyle.copyWith(color: errorColor),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return white;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return white;
        }),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: darkPrimaryColor,
        secondary: darkAccentColor,
        error: errorColor,
        surface: darkSurface,
        onPrimary: darkBg,
        onSecondary: darkBg,
        onError: white,
        onSurface: darkTextPrimary,
      ),
      scaffoldBackgroundColor: darkBg,
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurfaceVariant,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _titleLargeStyleDark.copyWith(color: darkTextPrimary),
      ),
      textTheme: TextTheme(
        displayLarge: _displayLargeStyleDark,
        displayMedium: _displayMediumStyleDark,
        displaySmall: _displaySmallStyleDark,
        headlineMedium: _headlineMediumStyleDark,
        headlineSmall: _headlineSmallStyleDark,
        titleLarge: _titleLargeStyleDark,
        titleMedium: _titleMediumStyleDark,
        titleSmall: _titleSmallStyleDark,
        bodyLarge: _bodyLargeStyleDark,
        bodyMedium: _bodyMediumStyleDark,
        bodySmall: _bodySmallStyleDark,
        labelLarge: _labelLargeStyleDark,
        labelMedium: _labelMediumStyleDark,
        labelSmall: _labelSmallStyleDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryColor,
          foregroundColor: darkBg,
          minimumSize: const Size(minTouchSize, minTouchSize),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: _labelLargeStyleDark,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: darkPrimaryLight,
          side: const BorderSide(color: darkPrimaryLight),
        ),
      ),
      iconTheme: const IconThemeData(
        size: minTouchSize,
        color: darkTextPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkSurfaceVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkSurfaceVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        fillColor: darkSurfaceVariant,
        filled: true,
        hintStyle: _bodyMediumStyleDark.copyWith(color: darkTextSecondary),
        labelStyle: _bodyMediumStyleDark,
        errorStyle: _bodySmallStyleDark.copyWith(color: errorColor),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimaryColor;
          }
          return darkSurfaceVariant;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimaryColor;
          }
          return darkSurfaceVariant;
        }),
      ),
    );
  }

  // Text Styles with good readability
  static const TextStyle _displayLargeStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _displayMediumStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _displaySmallStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _headlineMediumStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _headlineSmallStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _titleLargeStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _titleMediumStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _titleSmallStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _bodyLargeStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle _bodyMediumStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle _bodySmallStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle _labelLargeStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle _labelMediumStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle _labelSmallStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ===== DARK MODE TEXT STYLES =====
  static const TextStyle _displayLargeStyleDark = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _displayMediumStyleDark = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _displaySmallStyleDark = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _headlineMediumStyleDark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _headlineSmallStyleDark = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _titleLargeStyleDark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _titleMediumStyleDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _titleSmallStyleDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle _bodyLargeStyleDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: darkTextPrimary,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle _bodyMediumStyleDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: darkTextPrimary,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle _bodySmallStyleDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: darkTextSecondary,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle _labelLargeStyleDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle _labelMediumStyleDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle _labelSmallStyleDark = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: darkTextPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );
}
