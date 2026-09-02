/// Estado de sesión. Escrito a mano (sin freezed) igual que en Planogether.
class AuthState {
  const AuthState({
    required this.isAuthenticated,
    this.uid,
    this.email,
    this.displayName,
  });

  static const initial = AuthState(isAuthenticated: false);

  final bool isAuthenticated;

  /// El id de usuario estable de Firebase Auth — el valor correcto para
  /// `ownerId` de los libros del usuario con sesión iniciada.
  final String? uid;
  final String? email;
  final String? displayName;

  AuthState copyWith({
    bool? isAuthenticated,
    String? uid,
    String? email,
    String? displayName,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }
}
