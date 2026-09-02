/// Un amigo: la otra persona de una `connections/{id}` en la que participa el
/// usuario con sesión. Los datos visibles vienen de su perfil público
/// (`users/{uid}`).
class Friend {
  const Friend({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.connectionId,
    this.since,
  });

  final String uid;
  final String displayName;
  final String email;

  /// Id del documento `connections/{id}` que une a ambos — lo necesita
  /// `removeFriend`.
  final String connectionId;

  final DateTime? since;

  /// Nombre a mostrar, con recurso al email si el perfil no tiene nombre.
  String get label => displayName.isNotEmpty ? displayName : email;
}
