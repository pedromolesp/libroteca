import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tomora/core/ads/ads_service.dart';
import 'package:tomora/core/config/di/dependency_injector.dart';
import 'package:tomora/core/config/firebase/firebase_bootstrap.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/tomora_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: transparent),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final firebaseReady = await bootstrapFirebase();
  await initDi(firebaseReady: firebaseReady);

  // Arranque del SDK de anuncios (consentimiento + ATT + MobileAds). No se
  // espera para no retrasar el primer frame — el banner espera a AdsService.ready.
  unawaited(getIt<AdsService>().initialize());

  runApp(const TomoraApp());
}
