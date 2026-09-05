import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/constants/app_constants.dart';
import 'package:tomora/core/routes/routes.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/core/widgets/brand_emblem.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_cubit.dart';

/// Pantalla de carga animada. El marrón se expande en círculo desde el centro
/// hasta llenar la pantalla (disimula el splash nativo), el emblema aparece en
/// el medio y luego "respira" mientras tres puntos laten en secuencia y el
/// nombre se desliza. El emblema comparte un [Hero] con el de la pantalla de
/// login. Al terminar decide el primer destino: la biblioteca si hay sesión, o
/// el login si no (con Firebase deshabilitado va directa a la biblioteca).
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  );
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  Timer? _navTimer;

  // El marrón circular crece durante los primeros ~70 % de la entrada
  // (~1,3 s) y frena al final (easeOutCubic).
  late final Animation<double> _reveal = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.05, 0.72, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _emblemScale =
      Tween<double>(begin: 0.7, end: 1).animate(CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.4, 0.85, curve: Curves.easeOutBack),
  ));
  late final Animation<double> _emblemFade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.38, 0.66, curve: Curves.easeOut),
  );
  late final Animation<double> _tailFade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.68, 1, curve: Curves.easeOut),
  );
  late final Animation<double> _tailSlide =
      Tween<double>(begin: 20, end: 0).animate(CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.68, 1, curve: Curves.easeOutCubic),
  ));

  @override
  void initState() {
    super.initState();
    _entrance.forward();
    _navTimer = Timer(AppConstants.splashDuration, () {
      if (!mounted) return;
      final auth = context.read<AuthCubit>();
      final goToLibrary = !auth.isEnabled || auth.state.isAuthenticated;
      context.goNamed(goToLibrary ? RouteNames.library : RouteNames.login);
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _entrance.dispose();
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // Un pelín más que la diagonal, para que al final no asome el crema en
    // las esquinas.
    final maxDiameter =
        1.06 * math.sqrt(size.width * size.width + size.height * size.height);
    final emblemSide = size.width * 0.30;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: primaryColorLight),

          // El marrón que crece desde el centro. `OverflowBox` deja que el
          // círculo sea más grande que la pantalla (si no, se recorta al ancho
          // y no llega a cubrir arriba y abajo).
          Center(
            child: AnimatedBuilder(
              animation: _reveal,
              builder: (context, _) {
                final d = maxDiameter * _reveal.value;
                return OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: Container(
                    width: d,
                    height: d,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFF7B5238),
                          primaryColorDark,
                          Color(0xFF3F2716),
                        ],
                        stops: [0, 0.62, 1],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([_entrance, _idle]),
                  builder: (context, child) {
                    final t = _idle.value * 2 * math.pi;
                    final breathe = 1 + 0.04 * math.sin(t);
                    final wobble = 0.05 * math.sin(t);
                    return Opacity(
                      opacity: _emblemFade.value,
                      child: Transform.rotate(
                        angle: wobble,
                        child: Transform.scale(
                          scale: _emblemScale.value * breathe,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: BrandEmblem(size: emblemSide, hero: true),
                ),
                SizedBox(height: emblemSide * 0.5),
                AnimatedBuilder(
                  animation: _entrance,
                  builder: (context, child) => Opacity(
                    opacity: _tailFade.value,
                    child: Transform.translate(
                      offset: Offset(0, _tailSlide.value),
                      child: child,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: whiteRed,
                          decoration: TextDecoration.none,
                          fontFamily: Fonts.muliBlack,
                          fontSize: size.width * 0.075,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _PulsingDots(controller: _idle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tres puntos que laten en secuencia, como indicador de carga.
class _PulsingDots extends StatelessWidget {
  const _PulsingDots({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (controller.value - i * 0.18) % 1.0;
            final wave = math.max(0.0, math.sin(phase * math.pi));
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: whiteRed.withValues(alpha: 0.35 + 0.55 * wave),
              ),
            );
          }),
        );
      },
    );
  }
}
