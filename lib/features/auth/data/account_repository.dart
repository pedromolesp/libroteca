import 'package:cloud_functions/cloud_functions.dart';

/// Llama a la Cloud Function `deleteAccount`, que borra (con el Admin SDK)
/// la cuenta de Firebase Auth de quien llama, su perfil, su código de
/// invitación y sus amistades — un cliente no puede borrar su propio usuario
/// de Auth ni tocar documentos de otras cuentas directamente.
class AccountRepository {
  AccountRepository({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  /// `true` si la cuenta quedó eliminada.
  Future<bool> deleteAccount() async {
    try {
      await _functions
          .httpsCallable('deleteAccount')
          .call<Map<String, dynamic>>();
      return true;
    } on FirebaseFunctionsException {
      return false;
    }
  }
}
