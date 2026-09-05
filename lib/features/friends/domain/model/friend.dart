/// Estado de una `connections/{id}`: `pending` hasta que la otra persona la
/// acepta, `accepted` en cuanto lo hace.
enum ConnectionStatus { pending, accepted }

/// Una relación con otra cuenta — amigo aceptado o solicitud pendiente (en
/// cualquiera de los dos sentidos). Los datos visibles vienen de su perfil
/// público (`users/{uid}`).
class Friend {
  const Friend({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.connectionId,
    required this.status,
    required this.requestedByMe,
    this.since,
  });

  final String uid;
  final String displayName;
  final String email;

  /// Id del documento `connections/{id}` que une a ambos — lo necesitan
  /// `respond` y `removeFriend`.
  final String connectionId;

  final ConnectionStatus status;

  /// `true` si quien tiene sesión fue quien envió la solicitud (relevante
  /// mientras [status] es `pending`: distingue "esperando respuesta" de
  /// "tienes que responder").
  final bool requestedByMe;

  final DateTime? since;

  bool get isPending => status == ConnectionStatus.pending;

  /// Nombre a mostrar, con recurso al email si el perfil no tiene nombre.
  String get label => displayName.isNotEmpty ? displayName : email;
}
