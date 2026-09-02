// Opciones de Firebase para Tomora (proyecto `tomora-df39a`).
//
// Equivalente a lo que genera `flutterfire configure`, escrito a mano a partir
// de `android/app/google-services.json` y `ios/Runner/GoogleService-Info.plist`.
// Si en el futuro se ejecuta `flutterfire configure`, este archivo se
// regenerará y puede sobrescribirse sin problema.
//
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Uso: `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Tomora no tiene configuración de Firebase para web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está configurado para $defaultTargetPlatform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfLl2ayZ4DTkWlNLMeuiazyQagQ2BrxLo',
    appId: '1:12154763970:android:c9478107150bf683e8595b',
    messagingSenderId: '12154763970',
    projectId: 'tomora-df39a',
    storageBucket: 'tomora-df39a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCh6aH-eGjmbfKu-G_d2Yv-433RogfSOes',
    appId: '1:12154763970:ios:eae1c18e842a7b37e8595b',
    messagingSenderId: '12154763970',
    projectId: 'tomora-df39a',
    storageBucket: 'tomora-df39a.firebasestorage.app',
    iosBundleId: 'com.pedrogrameitor.tomora',
  );
}
