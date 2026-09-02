import 'package:flutter/material.dart';
import 'package:tomora/core/constants/app_constants.dart';
import 'package:tomora/core/theme/app_colors.dart';

/// Logo giratorio de la pantalla de carga. Versión simplificada del antiguo
/// `LogoWidget` (que hacía `setState` en un `Future.delayed` sin comprobar
/// `mounted` y era `must_be_immutable`).
class LogoWidget extends StatefulWidget {
  const LogoWidget({super.key, required this.size});

  final Size size;

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final side = widget.size.height * 0.18;
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        AppAssets.logo,
        width: side,
        height: side,
        color: primaryColor,
        colorBlendMode: BlendMode.color,
        fit: BoxFit.contain,
      ),
    );
  }
}
