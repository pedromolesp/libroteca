import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/constants/app_constants.dart';
import 'package:tomora/core/routes/routes.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/theme/app_fonts.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:tomora/features/library/presentation/widgets/logo_widget.dart';

/// Pantalla de carga. El antiguo `LoadingPage` programaba la navegación dentro
/// de `build()` sin comprobar `mounted` (navegaba en un contexto muerto o
/// varias veces); aquí el temporizador vive en `initState` y se cancela.
///
/// Al terminar decide el primer destino: la biblioteca si hay sesión (Firebase
/// la restaura entre reinicios), o el login si no. Con Firebase deshabilitado
/// ("modo offline") va directa a la biblioteca local.
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashDuration, () {
      if (!mounted) return;
      final auth = context.read<AuthCubit>();
      final goToLibrary = !auth.isEnabled || auth.state.isAuthenticated;
      context.goNamed(goToLibrary ? RouteNames.library : RouteNames.login);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height,
      color: primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(size: size),
            SizedBox(height: size.height * 0.1),
            Text(
              AppConstants.appName,
              style: TextStyle(
                color: whiteRed,
                decoration: TextDecoration.none,
                fontFamily: Fonts.muliBlack,
                fontSize: size.width * 0.05,
              ),
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
