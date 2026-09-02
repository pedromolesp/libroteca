import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomora/features/auth/domain/model/user_profile.dart';

/// Se lanza dentro de la transacción de [UsersRepository.claimReferralCode]
/// cuando el código elegido al azar ya está cogido, para reintentar.
class _ReferralCodeTaken implements Exception {}

/// Lee/escribe la colección pública `users` — ver `firestore.rules`: cualquier
/// usuario autenticado puede leer cualquier perfil (para buscarse por email),
/// pero solo el dueño escribe su identidad; los campos de recompensa de
/// referidos son solo de servidor (función `redeemReferral`).
class UsersRepository {
  UsersRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users');

  /// Escribe los campos de identidad (y `createdAt` en la primera escritura),
  /// dejando intactos los campos gestionados por el servidor.
  Future<void> upsertProfile(UserProfile profile) {
    return _collection.doc(profile.uid).set({
      ...profile.toIdentityMap(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<UserProfile?> watchProfile(String uid) {
    return _collection.doc(uid).snapshots().map((doc) {
      final data = doc.data();
      return data == null ? null : UserProfile.fromMap(doc.id, data);
    });
  }

  /// Reserva un código único para [uid] creando un documento en
  /// `referralCodes` (id = el código), reintentando ante la rara colisión.
  Future<String> claimReferralCode(String uid) async {
    // Alfabeto tipo Crockford: sin I/O/0/1, fácil de leer en voz alta.
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();

    for (var attempt = 0; attempt < 5; attempt++) {
      final code = List.generate(
        6,
        (_) => alphabet[random.nextInt(alphabet.length)],
      ).join();
      final ref = _firestore.collection('referralCodes').doc(code);
      try {
        await _firestore.runTransaction((tx) async {
          final snap = await tx.get(ref);
          if (snap.exists) throw _ReferralCodeTaken();
          tx.set(ref, {'uid': uid});
        });
        return code;
      } on _ReferralCodeTaken {
        continue;
      }
    }
    throw StateError('No se pudo asignar un código de referido para $uid');
  }

  /// Busca una cuenta por email exacto, o `null` si no hay ninguna.
  Future<UserProfile?> findByEmail(String email) async {
    final snapshot =
        await _collection.where('email', isEqualTo: email).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return UserProfile.fromMap(doc.id, doc.data());
  }
}
