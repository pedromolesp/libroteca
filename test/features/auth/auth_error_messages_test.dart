import 'package:flutter_test/flutter_test.dart';
import 'package:tomora/features/auth/presentation/auth_error_messages.dart';

void main() {
  group('authErrorMessage', () {
    test('mapea códigos conocidos a un mensaje distinto del genérico', () {
      const knownCodes = [
        'invalid-email',
        'user-disabled',
        'user-not-found',
        'wrong-password',
        'invalid-credential',
        'email-already-in-use',
        'weak-password',
        'operation-not-allowed',
        'account-exists-with-different-credential',
        'google-sign-in-failed',
        'network-request-failed',
      ];
      final generic = authErrorMessage('codigo-inventado-que-no-existe');
      for (final code in knownCodes) {
        expect(
          authErrorMessage(code),
          isNot(equals(generic)),
          reason: '"$code" debería tener un mensaje propio',
        );
      }
    });

    test('códigos desconocidos y null caen en el mensaje genérico', () {
      final generic = authErrorMessage('codigo-inventado-que-no-existe');
      expect(authErrorMessage(null), generic);
      expect(authErrorMessage('otro-codigo-desconocido'), generic);
    });
  });
}
