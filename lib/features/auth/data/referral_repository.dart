import 'package:cloud_functions/cloud_functions.dart';

/// Resultado de intentar canjear el código de referido de otra persona.
enum RedeemResult {
  ok,

  /// No hay ninguna cuenta registrada con ese código.
  unknownCode,

  /// Has introducido tu propio código.
  ownCode,

  /// Esta cuenta ya canjeó un código (solo cuenta una vez).
  alreadyRedeemed,

  /// La cuenta está fuera de la ventana en la que se puede canjear.
  tooLate,

  /// Error de red / servidor — se puede reintentar.
  failed,
}

/// Llama a la Cloud Function `redeemReferral`, que valida y hace las escrituras
/// entre cuentas (un cliente no puede tocar el perfil de otro usuario).
class ReferralRepository {
  ReferralRepository({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  Future<RedeemResult> redeem(String code) async {
    try {
      await _functions
          .httpsCallable('redeemReferral')
          .call<Map<String, dynamic>>({'code': code.trim().toUpperCase()});
      return RedeemResult.ok;
    } on FirebaseFunctionsException catch (e) {
      return switch (e.code) {
        'not-found' => RedeemResult.unknownCode,
        'failed-precondition' when e.message == 'own-code' =>
          RedeemResult.ownCode,
        'failed-precondition' when e.message == 'too-late' =>
          RedeemResult.tooLate,
        'already-exists' => RedeemResult.alreadyRedeemed,
        _ => RedeemResult.failed,
      };
    } catch (_) {
      return RedeemResult.failed;
    }
  }
}
