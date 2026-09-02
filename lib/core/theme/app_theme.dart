import 'package:flutter/material.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';

/// Tema de la aplicación. De momento solo modo claro (el proyecto no tenía
/// tema oscuro); se deja como clase para poder añadir `dark` más adelante,
/// igual que en Planogether.
abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: false,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: primaryBackgroundColor,
        iconTheme: const IconThemeData(color: black),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: primaryColorDark,
          iconColor: primaryColor,
          suffixIconColor: black,
          prefixIconColor: black,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColorDark),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: primaryColor,
          unselectedLabelColor: white,
          unselectedLabelStyle: TextStyle(color: white),
          labelStyle: TextStyle(color: primaryColor),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: primaryColorDark,
          indicatorColor: whiteRed.withValues(alpha: 0.18),
          elevation: 0,
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? whiteRed
                  : whiteRed.withValues(alpha: 0.6),
            ),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontFamily: Fonts.muliBold,
              fontSize: 12,
              color: states.contains(WidgetState.selected)
                  ? whiteRed
                  : whiteRed.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
}
