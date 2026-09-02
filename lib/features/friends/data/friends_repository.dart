import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomora/features/friends/domain/model/friend.dart';

/// Resultado de intentar añadir a alguien como amigo por su código de invitación.
enum AddFriendResult { ok, unknownCode, ownCode, alreadyFriends, failed }

/// Amistades entre cuentas, guardadas en `connections/{id}` con
/// `{ members: [uidA, uidB], createdAt }` (id = los dos uid ordenados y unidos
/// por `__`). Solo los dos miembros pueden leer o borrar el documento
/// (ver `firestore.rules`).
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

  /// Amigos del usuario [myUid], en vivo. Combina cada `connections` en la que
  /// participa con el perfil público del otro miembro.
  Stream<List<Friend>> watchFriends(String myUid) {
    return _connections
        .where('members', arrayContains: myUid)
        .snapshots()
        .asyncMap((snap) async {
      final friends = await Future.wait(snap.docs.map((doc) async {
        final members = List<String>.from(doc.data()['members'] as List);
        final otherUid = members.firstWhere((u) => u != myUid, orElse: () => '');
        if (otherUid.isEmpty) return null;

        final profile =
            await _firestore.collection('users').doc(otherUid).get();
        final data = profile.data() ?? const {};
        return Friend(
          uid: otherUid,
          displayName: (data['displayName'] as String?) ?? '',
          email: (data['email'] as String?) ?? '',
          connectionId: doc.id,
          since: (doc.data()['createdAt'] as Timestamp?)?.toDate(),
        );
      }));
      return friends.whereType<Friend>().toList()
        ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    });
  }

  /// Añade como amigo a quien posea el código de invitación [code].
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
        'createdAt': FieldValue.serverTimestamp(),
      });
      return AddFriendResult.ok;
    } on FirebaseException {
      return AddFriendResult.failed;
    }
  }

  /// Deshace la amistad. El borrado del documento dispara la limpieza de datos
  /// compartidos en `onConnectionDeleted`.
  Future<bool> removeFriend(String connectionId) async {
    try {
      await _connections.doc(connectionId).delete();
      return true;
    } on FirebaseException {
      return false;
    }
  }
}
