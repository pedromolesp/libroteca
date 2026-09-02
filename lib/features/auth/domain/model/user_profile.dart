import 'package:cloud_firestore/cloud_firestore.dart';

/// Perfil público mínimo de una cuenta registrada — permite que otros usuarios
/// la encuentren por email y sostiene el estado de referidos / anuncios.
///
/// Los campos de recompensa (`referredBy`, `referralCount`, `adsFreeUntil`) solo
/// los escribe la función `redeemReferral` (Admin SDK); el cliente solo escribe
/// su identidad (ver `firestore.rules`).
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.referralCode = '',
    this.referredBy,
    this.referralCount = 0,
    this.adsFreeUntil,
  });

  final String uid;
  final String email;
  final String displayName;

  /// El código para compartir de esta cuenta. Se genera al registrarse; otras
  /// personas lo canjean con la función `redeemReferral`.
  final String referralCode;

  /// El uid de quien invitó a esta cuenta, o `null`. Se fija una sola vez.
  final String? referredBy;

  /// Cuántas personas han canjeado el [referralCode] de esta cuenta.
  final int referralCount;

  /// Los anuncios están ocultos hasta este momento. `null` o en el pasado →
  /// se muestran anuncios. Lo extiende `redeemReferral` en cada invitación.
  final DateTime? adsFreeUntil;

  /// Si a este usuario se le deben mostrar anuncios ahora mismo.
  bool get adsEnabled =>
      adsFreeUntil == null || adsFreeUntil!.isBefore(DateTime.now());

  /// Los campos que este cliente puede escribir (ver `firestore.rules`).
  /// Merge, no sobrescribir.
  Map<String, dynamic> toIdentityMap() {
    return {
      'email': email,
      'displayName': displayName,
      'referralCode': referralCode,
    };
  }

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      referralCode: map['referralCode'] as String? ?? '',
      referredBy: map['referredBy'] as String?,
      referralCount: (map['referralCount'] as num?)?.toInt() ?? 0,
      adsFreeUntil: (map['adsFreeUntil'] as Timestamp?)?.toDate(),
    );
  }
}
