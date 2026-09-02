import 'package:flutter/material.dart';
import 'package:tomora/core/constants/app_constants.dart';
import 'package:tomora/core/theme/app_colors.dart';

/// Emblema de marca de Tomora: el icono del libro (ya en tonos marrones dentro
/// de su disco) sobre un aro crema con sombra suave. Se usa idéntico en la
/// pantalla de carga y en la de sesión; con [hero] activo vuela de una a otra
/// con una animación Hero para dar continuidad.
class BrandEmblem extends StatelessWidget {
  const BrandEmblem({super.key, required this.size, this.hero = false});

  final double size;

  /// Envuelve el emblema en un [Hero] para la transición carga → login.
  /// Solo debe activarse en UNA pantalla visible a la vez (login sí, registro
  /// no) o Flutter se queja de tags duplicados.
  final bool hero;

  static const heroTag = 'tomora-brand-emblem';

  @override
  Widget build(BuildContext context) {
    final emblem = Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.055),
      decoration: BoxDecoration(
        color: whiteRed,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
      ),
    );

    if (!hero) return emblem;
    return Hero(tag: heroTag, child: emblem);
  }
}
