import 'dart:io';

import 'package:flutter/foundation.dart';

/// Identificadores de AdMob.
///
/// En builds **release** se usan las unidades reales; en debug/profile se
/// sirven las unidades **de test** públicas de Google, así `flutter run` nunca
/// arriesga sanciones por tráfico inválido.
///
/// Los identificadores de **aplicación** de AdMob viven en
/// `AndroidManifest.xml` e `Info.plist`.
abstract final class AdConfig {
  /// Fuerza un banner de test aunque no haya backend Firebase. Útil en
  /// desarrollo para ver el hueco del anuncio. Ponlo en `false` para producción.
  static const forceTestBannerInDev = false;

  // Unidades de banner de test públicas de Google.
  static const _testAndroidBanner = 'ca-app-pub-3940256099942544/9214589741';
  static const _testIosBanner = 'ca-app-pub-3940256099942544/2435281174';

  // TODO(tomora): sustituir por las unidades reales de la consola de AdMob.
  static const _androidBanner = _testAndroidBanner;
  static const _iosBanner = _testIosBanner;

  /// La unidad de banner para la plataforma y el modo de build actuales.
  static String get bannerUnitId {
    if (kIsWeb) return _testAndroidBanner; // en web no se muestran anuncios
    if (!kReleaseMode) {
      return Platform.isIOS ? _testIosBanner : _testAndroidBanner;
    }
    return Platform.isIOS ? _iosBanner : _androidBanner;
  }
}
