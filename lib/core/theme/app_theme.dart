import 'package:flutter/material.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';

/// Tema de la aplicación, en modo claro y oscuro. El marrón de marca
/// (`primaryColorDark`/`primaryColor`) y el crema sobre él (`whiteRed`) no
/// cambian con el tema — son la identidad de Tomora, igual en ambos, como en
/// [NavigationBar]. Lo que sí cambia son las superficies y el texto sobre
/// ellas: ver [AppSurfaceColors].
abstract final class AppTheme {
  static ThemeData get light => _themeFor(AppSurfaceColors.light);
  static ThemeData get dark => _themeFor(AppSurfaceColors.dark);

  static ThemeData _themeFor(AppSurfaceColors colors) {
    return ThemeData(
      useMaterial3: false,
      brightness:
          colors == AppSurfaceColors.dark ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      cardColor: colors.surface,
      dialogTheme: DialogThemeData(backgroundColor: colors.surface),
      iconTheme: IconThemeData(color: colors.onSurface),
      textTheme: Typography.material2018()
          .black
          .apply(bodyColor: colors.onSurface, displayColor: colors.onSurface),
      inputDecorationTheme: InputDecorationTheme(
        focusColor: primaryColorDark,
        iconColor: primaryColor,
        suffixIconColor: colors.onSurface,
        prefixIconColor: colors.onSurface,
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
}
