import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomora/features/friends/domain/model/friend.dart';

/// Resultado de intentar añadir a alguien como amigo por su código de invitación.
enum AddFriendResult { ok, unknownCode, ownCode, alreadyFriends, failed }

/// Amistades entre cuentas, guardadas en `connections/{id}` con
/// `{ members: [uidA, uidB], status: 'pending'|'accepted', requestedBy,
/// createdAt }` (id = los dos uid ordenados y unidos por `__`).
///
/// Añadir a alguien crea la conexión en `pending`; solo queda en `accepted`
/// cuando la otra persona la acepta explícitamente — ver `firestore.rules`,
/// que solo permite esa transición al miembro que **no** la solicitó. Solo los
/// dos miembros pueden leer o borrar el documento.
///
/// Al borrar una amistad, un disparador de Cloud Functions
/// (`onConnectionDeleted`) limpia la información compartida entre ambos —
/// un cliente no puede tocar los datos del otro usuario.
class FriendsRepository {
  FriendsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _connections =>
      _firestore.collection('connections');

  static String connectionId(String a, String b) {
    final pair = [a, b]..sort();
    return pair.join('__');
  }

  /// Todas las conexiones de [myUid] (aceptadas y pendientes en ambos
  /// sentidos), combinadas con el perfil público del otro miembro. La cubit
  /// separa por [Friend.status] / [Friend.requestedByMe].
  Stream<List<Friend>> watchConnections(String myUid) {
    return _connections
        .where('members', arrayContains: myUid)
        .snapshots()
        .asyncMap((snap) async {
      final friends = await Future.wait(snap.docs.map((doc) async {
        final data = doc.data();
        final members = List<String>.from(data['members'] as List);
        final otherUid =
            members.firstWhere((u) => u != myUid, orElse: () => '');
        if (otherUid.isEmpty) return null;

        final profile =
            await _firestore.collection('users').doc(otherUid).get();
        final profileData = profile.data() ?? const {};
        return Friend(
          uid: otherUid,
          displayName: (profileData['displayName'] as String?) ?? '',
          email: (profileData['email'] as String?) ?? '',
          connectionId: doc.id,
          status: data['status'] == 'accepted'
              ? ConnectionStatus.accepted
              : ConnectionStatus.pending,
          requestedByMe: data['requestedBy'] == myUid,
          since: (data['createdAt'] as Timestamp?)?.toDate(),
        );
      }));
      return friends.whereType<Friend>().toList()
        ..sort(
            (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    });
  }

  /// Envía una solicitud de amistad a quien posea el código de invitación
  /// [code]. Queda en `pending` hasta que la otra persona la acepte.
  Future<AddFriendResult> addFriendByCode(String myUid, String code) async {
    final trimmed = code.trim().toUpperCase();
    if (!RegExp(r'^[A-Z0-9]{6}$').hasMatch(trimmed)) {
      return AddFriendResult.unknownCode;
    }
    try {
      final codeSnap =
          await _firestore.collection('referralCodes').doc(trimmed).get();
      final friendUid = codeSnap.data()?['uid'] as String?;
      if (friendUid == null) return AddFriendResult.unknownCode;
      if (friendUid == myUid) return AddFriendResult.ownCode;

      final ref = _connections.doc(connectionId(myUid, friendUid));
      if ((await ref.get()).exists) return AddFriendResult.alreadyFriends;

      await ref.set({
        'members': [myUid, friendUid],
        'status': 'pending',
        'requestedBy': myUid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return AddFriendResult.ok;
    } on FirebaseException {
      return AddFriendResult.failed;
    }
  }

  /// Acepta o rechaza una solicitud entrante. Rechazar borra la conexión
  /// (igual que deshacer una amistad ya aceptada).
  Future<bool> respondToRequest(String connectionId,
      {required bool accept}) async {
    try {
      if (accept) {
        await _connections.doc(connectionId).update({
          'status': 'accepted',
          'respondedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await _connections.doc(connectionId).delete();
      }
      return true;
    } on FirebaseException {
      return false;
    }
  }

  /// Deshace la amistad (o cancela una solicitud propia pendiente). El
  /// borrado dispara la limpieza de datos compartidos en `onConnectionDeleted`.
  Future<bool> removeFriend(String connectionId) async {
    try {
      await _connections.doc(connectionId).delete();
      return true;
    } on FirebaseException {
      return false;
    }
  }
}
