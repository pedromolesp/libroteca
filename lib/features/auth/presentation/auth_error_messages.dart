/// Traduce un `FirebaseAuthException.code` a un mensaje en español.
String authErrorMessage(String? code) {
  return switch (code) {
    'invalid-email' => 'El email no es válido.',
    'user-disabled' => 'Esta cuenta está deshabilitada.',
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' =>
      'Email o contraseña incorrectos.',
    'email-already-in-use' => 'Ya existe una cuenta con ese email.',
    'weak-password' =>
      'La contraseña es demasiado débil (mínimo 6 caracteres).',
    'operation-not-allowed' =>
      'El inicio de sesión aún no está disponible (falta configurar Firebase).',
    'account-exists-with-different-credential' =>
      'Ya hay una cuenta con ese email usando otro método de acceso.',
    'google-sign-in-failed' => 'No se pudo iniciar sesión con Google.',
    'network-request-failed' => 'Sin conexión. Inténtalo de nuevo.',
    _ => 'Algo ha ido mal. Inténtalo de nuevo.',
  };
}
