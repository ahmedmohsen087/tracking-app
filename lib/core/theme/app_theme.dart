import 'package:flowery_driver_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.pink,
      primary: AppColors.pink,
      onPrimary: AppColors.white,
      secondary: AppColors.lightPink,
      onSecondary: AppColors.pink,
      surface: AppColors.white,
      onSurface: AppColors.black,
      error: AppColors.red,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.white,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.pink,
      linearTrackColor: AppColors.lightPink,
      circularTrackColor: AppColors.lightPink,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyles.appBarTextStyle,
      backgroundColor: AppColors.white,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: AppColors.black, size: 24),
      leadingWidth: 40,
      foregroundColor: AppColors.black,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyles.appBarTextStyle,
      bodyLarge: TextStyles.bodyRegular16,
      bodyMedium: TextStyles.bodyRegular14,
      bodySmall: TextStyles.bodyRegular12,
      labelLarge: TextStyles.buttonTextStyle,
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconConstraints: const BoxConstraints(minHeight: 24, maxHeight: 24),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return TextStyles.labelTextFieldStyle.copyWith(color: AppColors.red);
        }
        if (states.contains(WidgetState.focused)) {
          return TextStyles.labelTextFieldStyle.copyWith(
            color: AppColors.black,
          );
        }
        return TextStyles.labelTextFieldStyle;
      }),
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyles.labelTextFieldStyle,
      errorStyle: TextStyles.errorTextFieldStyle,
      hintStyle: TextStyles.hintTextFieldStyle,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.grey, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.grey;
          }
          return AppColors.pink;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.white),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        ),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 48)),
        shape: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.disabled)
              ? AppColors.grey
              : AppColors.pink;
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: color),
          );
        }),
        textStyle: WidgetStateProperty.all(TextStyles.buttonTextStyle),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.white),
        foregroundColor: WidgetStateProperty.all(AppColors.grey),
        overlayColor: WidgetStateProperty.all(AppColors.lightPink),
        side: WidgetStateProperty.all(BorderSide(color: AppColors.grey)),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        ),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 48)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: AppColors.grey),
          ),
        ),
        textStyle: WidgetStateProperty.all(TextStyles.buttonTextStyle),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightPink,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: AppColors.pink),
      unselectedIconTheme: IconThemeData(color: AppColors.grey),
      selectedLabelStyle: TextStyles.bodyRegular12.copyWith(
        color: AppColors.pink,
      ),
      unselectedLabelStyle: TextStyles.bodyRegular12.copyWith(
        color: AppColors.grey,
      ),
    ),
  );
}
