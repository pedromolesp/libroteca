import 'package:flutter/material.dart';
import 'package:tomora/core/theme/app_colors.dart';

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
      );
}
