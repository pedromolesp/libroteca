import 'package:flutter/material.dart';

/// Paleta de la aplicación. Los nombres se conservan del código original para
/// minimizar el ruido al portar pantallas; el hogar canónico es este archivo.
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
const Color primaryColorLight = orangeLight;
const Color secondaryColor = primaryColor;
const Color textActiveColor = black;
const Color textInactiveColor = white;
const Color textSecondaryColor = greyText;
const Color primaryBackgroundColor = white;

/// Negro al 20 % — usado en sombras. No puede ser `const` por `withValues`.
final Color black20 = Colors.black.withValues(alpha: 0.2);
