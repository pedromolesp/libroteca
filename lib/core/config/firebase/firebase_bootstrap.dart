import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:tomora/core/constants/app_constants.dart';
import 'package:tomora/firebase_options.dart';

/// Arranca Firebase con las opciones del proyecto `tomora-df39a` (ver
/// [DefaultFirebaseOptions]). Es tolerante a fallos: si la inicialización lanza
/// (config corrupta, sin red la primera vez, App Check rechazado...), la app
/// sigue en "modo offline" — la biblioteca local (sqflite) funciona y auth /
/// referidos / anuncios quedan dormidos.
///
/// Devuelve `true` si Firebase quedó operativo.
Future<bool> bootstrapFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // App Check: atestigua que las peticiones vienen del binario real. Solo si
    // está configurado en la consola (ver [AppConstants.enableAppCheck]).
    if (AppConstants.enableAppCheck) {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: kReleaseMode
            ? const AndroidPlayIntegrityProvider()
            : const AndroidDebugProvider(),
        providerApple: kReleaseMode
            ? const AppleAppAttestWithDeviceCheckFallbackProvider()
            : const AppleDebugProvider(),
      );
    }

    // Crashlytics apagado en debug para no ensuciar el panel; Analytics activo
    // en todos los modos (el tráfico de debug se inspecciona en DebugView).
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    return true;
  } catch (error) {
    debugPrint(
      'Firebase aún no configurado ($error) — la app arranca en modo offline. '
      'Ejecuta `flutterfire configure` para activar auth, Firestore y anuncios.',
    );
    return false;
  }
}
