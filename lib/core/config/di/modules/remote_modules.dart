part of '../dependency_injector.dart';

/// Instancias de Firebase. Solo se registran si `flutterfire configure` ya se
/// ejecutó (`firebaseReady`); si no, acceder a `FirebaseXxx.instance` lanzaría.
void _remoteModulesInit({required bool firebaseReady}) {
  if (!firebaseReady) return;
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseFunctions>(
    () => FirebaseFunctions.instance,
  );
}
