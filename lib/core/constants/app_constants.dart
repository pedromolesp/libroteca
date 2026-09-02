/// Constantes globales de la aplicación.
abstract final class AppConstants {
  static const appName = 'Tomora';

  /// Segundos que muestra la pantalla de carga antes de ir a la biblioteca.
  static const splashDuration = Duration(seconds: 2);
}

/// Rutas de los assets empaquetados.
abstract final class AppAssets {
  static const _images = 'assets/images';

  static const logo = '$_images/libro-logo.png';
  static const bookPlaceholder = '$_images/book_placeholder.png';
  static const diamond = '$_images/diamond.png';
  static const paper = '$_images/papel.png';
}
