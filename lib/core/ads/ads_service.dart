import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Gestiona el arranque único del SDK de anuncios: recoge el consentimiento de
/// privacidad (Google UMP), pide el permiso de seguimiento en iOS (ATT) e
/// inicializa el Mobile Ads SDK.
///
/// Todo es best-effort: si el consentimiento o la red fallan igualmente
/// inicializamos el SDK (podrá servir anuncios no personalizados) y nunca
/// bloqueamos el arranque de la app.
///
/// Es independiente de Firebase — se llama siempre, aunque no haya backend.
class AdsService {
  AdsService();

  final _ready = Completer<void>();
  var _started = false;
  var _canRequestAds = true;

  /// Se completa cuando [initialize] termina (con éxito o con fallo manejado).
  Future<void> get ready => _ready.future;

  /// Si el consentimiento permite pedir anuncios. `false` = no mostrar nada.
  bool get canRequestAds => _canRequestAds;

  /// Ejecuta el arranque una sola vez. Seguro de llamar desde `main()` sin await.
  Future<void> initialize() async {
    if (_started) return _ready.future;
    _started = true;

    try {
      await _gatherConsent();
    } catch (error) {
      debugPrint('AdsService: fallo en el consentimiento: $error');
    }

    try {
      if (!kIsWeb && Platform.isIOS) await _requestTracking();
    } catch (error) {
      debugPrint('AdsService: fallo en ATT: $error');
    }

    try {
      await MobileAds.instance.initialize();
    } catch (error) {
      debugPrint('AdsService: MobileAds.initialize falló: $error');
    }

    if (!_ready.isCompleted) _ready.complete();
  }

  Future<void> _gatherConsent() async {
    final completer = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        ConsentForm.loadAndShowConsentFormIfRequired((formError) {
          if (formError != null) {
            debugPrint(
                'AdsService: error del formulario: ${formError.message}');
          }
          if (!completer.isCompleted) completer.complete();
        });
      },
      (requestError) {
        debugPrint(
            'AdsService: error de consentimiento: ${requestError.message}');
        if (!completer.isCompleted) completer.complete();
      },
    );
    await completer.future;
    _canRequestAds = await ConsentInformation.instance.canRequestAds();
  }

  Future<void> _requestTracking() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
