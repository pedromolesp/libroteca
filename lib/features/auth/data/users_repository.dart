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

  /// Garantiza que existe `users/{uid}` para la cuenta con sesión. Idempotente:
  ///
  /// - Si el documento ya existe con código de referido, lo devuelve tal cual.
  /// - Si falta (cuenta creada en Auth pero no en Firestore por un fallo de red
  ///   o de reglas al registrarse, o primer inicio de sesión en otro
  ///   dispositivo), o existe pero sin código, reserva un código y lo crea.
  ///
  /// Se llama en cada cambio de sesión, así el perfil y el sistema de referidos
  /// se autoreparan sin depender de que el registro fuera perfecto.
  Future<UserProfile> ensureProfile({
    required String uid,
    String? email,
    String? displayName,
  }) async {
    final ref = _collection.doc(uid);
    final snap = await ref.get();
    final data = snap.data();
    final hasCode = ((data?['referralCode'] as String?) ?? '').isNotEmpty;

    if (data != null && hasCode) {
      return UserProfile.fromMap(snap.id, data);
    }

    final referralCode = await claimReferralCode(uid);
    final profile = UserProfile(
      uid: uid,
      email: email ?? (data?['email'] as String? ?? ''),
      displayName: displayName ?? (data?['displayName'] as String? ?? ''),
      referralCode: referralCode,
    );
    await upsertProfile(profile);
    return profile;
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
