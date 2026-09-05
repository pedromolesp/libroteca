import 'package:flutter/material.dart';

/// Paleta de la aplicación. Los nombres se conservan del código original para
/// minimizar el ruido al portar pantallas; el hogar canónico es este archivo.
///
/// Estas son las marcas de identidad de Tomora: se ven igual en claro y en
/// oscuro (el marrón de las barras y botones no "invierte" con el tema, igual
/// que el logo de una app no cambia de color).
const Color black = Color(0xFF231F20);
const Color red = Color(0xFFEF4B4B);
const Color white = Colors.white;
const Color yellow = Color(0xFFF3DFA2);
const Color whiteRed = Color(0xFFEFE6DD);
const Color transparent = Colors.transparent;
const Color orangeLight = Color.fromARGB(255, 248, 226, 182);
const Color primaryColor = Color.fromARGB(255, 182, 141, 114);
const Color white24 = Colors.white24;
const Color fillerGrey = Color(0xFF898A8F);
const Color greyText = Color(0xFF707070);
const Color green = Colors.green;
const Color primaryColorDark = Color.fromARGB(255, 97, 64, 42);

/// Fondo cálido muy suave para las pantallas principales en modo claro.
const Color primaryColorLight = Color(0xFFFBF5EC);

/// Crema del tono medio, para acentos sobre [primaryColorLight] (p. ej. el
/// carril del selector segmentado) en modo claro.
const Color creamAccent = Color(0xFFF3E6CC);

/// Negro al 20 % — usado en sombras. No puede ser `const` por `withValues`.
final Color black20 = Colors.black.withValues(alpha: 0.2);

/// Colores que **sí** cambian entre modo claro y oscuro: el fondo de las
/// pantallas, las superficies (tarjetas, diálogos, campos) y el texto que va
/// encima. Se accede a través de `context.colors` (ver [AppColorsX]) en vez de
/// como constantes sueltas.
class AppSurfaceColors {
  const AppSurfaceColors({
    required this.background,
    required this.trackBackground,
    required this.surface,
    required this.fieldFill,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  /// Fondo de las pantallas principales (biblioteca, ajustes, amigos...).
  final Color background;

  /// Fondo de carriles/segmentos sobre [background] (el selector
  /// Biblioteca/Leídos).
  final Color trackBackground;

  /// Tarjetas, diálogos, campos de texto: una superficie "elevada" sobre
  /// [background].
  final Color surface;

  /// Relleno de campos de texto dentro de una [surface] (p. ej. el formulario
  /// de login/registro), un tono ligeramente distinto para distinguirlos de
  /// la tarjeta que los contiene.
  final Color fieldFill;

  /// Texto e iconos principales sobre [background] / [surface].
  final Color onSurface;

  /// Texto e iconos secundarios (subtítulos, pistas, deshabilitado).
  final Color onSurfaceMuted;

  static const light = AppSurfaceColors(
    background: primaryColorLight,
    trackBackground: creamAccent,
    surface: white,
    fieldFill: Color(0xFFF6F0E8),
    onSurface: black,
    onSurfaceMuted: greyText,
  );

  static const dark = AppSurfaceColors(
    background: Color(0xFF1C1712),
    trackBackground: Color(0xFF362A1F),
    surface: Color(0xFF2A2119),
    fieldFill: Color(0xFF362A1F),
    onSurface: Color(0xFFEDE6DF),
    onSurfaceMuted: Color(0xFFB2A494),
  );
}

/// Atajo: `context.colors.background` en vez de acarrear `Theme.of(context)`
/// y comprobar el brillo a mano en cada sitio.
extension AppColorsX on BuildContext {
  AppSurfaceColors get colors => Theme.of(this).brightness == Brightness.dark
      ? AppSurfaceColors.dark
      : AppSurfaceColors.light;
}
