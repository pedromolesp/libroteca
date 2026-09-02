/// Constantes globales de la aplicación.
abstract final class AppConstants {
  static const appName = 'Tomora';

  /// Cuánto se muestra la pantalla de carga antes de navegar (deja margen para
  /// el relleno circular + la entrada del emblema + un respiro del pulso).
  static const splashDuration = Duration(milliseconds: 2900);

  /// Si se activa Firebase App Check en el arranque.
  ///
  /// Déjalo en `false` mientras App Check no esté bien configurado en la
  /// consola: si está *enforced* para Firestore/Functions y este dispositivo
  /// no tiene su *debug token* registrado, **todas** las llamadas devuelven
  /// `permission-denied` aunque las reglas sean correctas. Para activarlo:
  ///   1. Consola → App Check → registra el token de depuración que sale en
  ///      el log (`Firebase App Check debug token: …`) para builds debug, y
  ///      Play Integrity / App Attest para release.
  ///   2. Pon esto a `true`.
  static const enableAppCheck = false;
}

/// Rutas de los assets empaquetados.
abstract final class AppAssets {
  static const _images = 'assets/images';

  static const logo = '$_images/libro-logo.png';
  static const bookPlaceholder = '$_images/book_placeholder.png';
  static const diamond = '$_images/diamond.png';
  static const paper = '$_images/papel.png';
}
