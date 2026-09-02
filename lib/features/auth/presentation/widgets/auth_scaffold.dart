import 'package:flutter/material.dart';
import 'package:tomora/core/constants/app_constants.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/core/widgets/brand_emblem.dart';

/// Marco común de las pantallas de sesión (login y registro): fondo cálido con
/// degradado, la marca Tomora arriba y una tarjeta blanca redondeada con el
/// formulario. Mantiene ambas pantallas idénticas en estética y espaciado.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.heading,
    required this.subtitle,
    required this.child,
    this.footer,
    this.onBack,
    this.heroEmblem = false,
  });

  /// Título de la tarjeta (p. ej. "Inicia sesión").
  final String heading;

  /// Frase corta bajo el logotipo.
  final String subtitle;

  /// Contenido de la tarjeta (el formulario).
  final Widget child;

  /// Fila bajo la tarjeta (p. ej. el enlace a la otra pantalla).
  final Widget? footer;

  /// Si se indica, muestra una flecha de retroceso arriba a la izquierda.
  final VoidCallback? onBack;

  /// Envuelve el emblema en un [Hero] (solo en login, para la transición desde
  /// la pantalla de carga). En registro debe quedar `false`.
  final bool heroEmblem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      resizeToAvoidBottomInset: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3F2716), primaryColorDark, Color(0xFF7B5238)],
            stops: [0, 0.45, 1],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: onBack == null
                    ? null
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: whiteRed, size: 20),
                        ),
                      ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
                  child: Column(
                    children: [
                      BrandEmblem(size: 104, hero: heroEmblem),
                      const SizedBox(height: 18),
                      const Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: whiteRed,
                          fontFamily: Fonts.muliBlack,
                          fontSize: 32,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: whiteRed.withValues(alpha: 0.75),
                          fontFamily: Fonts.muliRegular,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.28),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              heading,
                              style: const TextStyle(
                                fontFamily: Fonts.muliExtraBold,
                                fontSize: 21,
                                color: black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            child,
                          ],
                        ),
                      ),
                      if (footer != null) ...[
                        const SizedBox(height: 20),
                        DefaultTextStyle(
                          style: TextStyle(
                            color: whiteRed.withValues(alpha: 0.85),
                            fontFamily: Fonts.muliRegular,
                            fontSize: 14,
                          ),
                          child: footer!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// [InputDecoration] uniforme para los campos de las pantallas de sesión:
/// relleno claro, esquinas redondeadas y sin borde salvo al enfocar/errar.
InputDecoration authInputDecoration(
  String label,
  IconData icon, {
  Widget? suffixIcon,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: color == transparent
            ? BorderSide.none
            : BorderSide(color: color, width: width),
      );

  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: greyText, fontFamily: Fonts.muliRegular),
    prefixIcon: Icon(icon, size: 20, color: primaryColorDark),
    prefixIconColor: primaryColorDark,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: const Color(0xFFF6F0E8),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    border: border(transparent),
    enabledBorder: border(transparent),
    focusedBorder: border(primaryColorDark, 1.6),
    errorBorder: border(red),
    focusedErrorBorder: border(red, 1.6),
  );
}

/// Botón principal de las pantallas de sesión, con estado de carga integrado.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorDark,
          foregroundColor: whiteRed,
          disabledBackgroundColor: primaryColor,
          disabledForegroundColor: whiteRed,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontFamily: Fonts.muliBold, fontSize: 16),
        ),
        onPressed: busy ? null : onPressed,
        child: busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: whiteRed,
                ),
              )
            : Text(label),
      ),
    );
  }
}

/// Separador "— texto —" entre el formulario y los accesos sociales.
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Divider(color: greyText.withValues(alpha: 0.4), thickness: 1),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(color: greyText, fontFamily: Fonts.muliRegular),
          ),
        ),
        line,
      ],
    );
  }
}

/// Botón blanco "Continuar con Google", con estado de carga.
class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: white,
          foregroundColor: black,
          side: BorderSide(color: greyText.withValues(alpha: 0.35)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontFamily: Fonts.muliBold, fontSize: 15),
        ),
        onPressed: busy ? null : onPressed,
        child: busy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.g_mobiledata,
                      size: 32, color: Color(0xFF4285F4)),
                  const SizedBox(width: 4),
                  Text(label),
                ],
              ),
      ),
    );
  }
}
