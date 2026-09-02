// Recompensa por referido = 90 días (~3 meses), solo para quien invita.
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp} from "firebase-admin/app";
import {getFirestore, FieldValue, Timestamp} from "firebase-admin/firestore";

initializeApp();
const db = getFirestore();

/** Días sin anuncios por invitación aceptada (~3 meses, acumulables). */
const REWARD_DAYS = 90;
/** Cuánto tiempo tras registrarse puede una cuenta canjear un código. */
const REDEEM_WINDOW_HOURS = 72;

/**
 * Canjea el código de referido de otro usuario. Valida el código, que quien
 * llama es una cuenta nueva que no ha canjeado antes, y luego, de forma
 * atómica:
 *  - marca a quien llama como referido,
 *  - registra la arista de referido,
 *  - incrementa el contador de quien invitó y extiende *su* `adsFreeUntil`.
 * Solo quien invita (el referrer) pierde los anuncios — el invitado los sigue
 * viendo. Todas las escrituras entre cuentas ocurren aquí porque un cliente no
 * puede escribir el perfil de otro usuario (ver `firestore.rules`).
 */
export const redeemReferral = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Inicia sesión primero.");
  }

  const code = String(request.data?.code ?? "").trim().toUpperCase();
  if (!/^[A-Z0-9]{6}$/.test(code)) {
    throw new HttpsError("invalid-argument", "Código con formato incorrecto.");
  }

  const codeSnap = await db.doc(`referralCodes/${code}`).get();
  if (!codeSnap.exists) {
    throw new HttpsError("not-found", "Código desconocido.");
  }
  const referrerId = codeSnap.get("uid") as string;
  if (referrerId === uid) {
    throw new HttpsError("failed-precondition", "own-code");
  }

  const inviteeRef = db.doc(`users/${uid}`);
  const referrerRef = db.doc(`users/${referrerId}`);
  const edgeRef = db.doc(`referrals/${referrerId}_${uid}`);

  await db.runTransaction(async (tx) => {
    const [invitee, referrer] = await Promise.all([
      tx.get(inviteeRef),
      tx.get(referrerRef),
    ]);

    if (!invitee.exists) {
      throw new HttpsError("failed-precondition", "Sin perfil.");
    }
    if (!referrer.exists) {
      throw new HttpsError("not-found", "El referrer ya no existe.");
    }
    if (invitee.get("referredBy")) {
      throw new HttpsError("already-exists", "Ya canjeado.");
    }

    const createdAt = invitee.get("createdAt") as Timestamp | undefined;
    if (
      createdAt &&
      Date.now() - createdAt.toMillis() > REDEEM_WINDOW_HOURS * 3600 * 1000
    ) {
      throw new HttpsError("failed-precondition", "too-late");
    }

    const now = Timestamp.now();
    const currentUntil = referrer.get("adsFreeUntil") as Timestamp | undefined;
    const base =
      currentUntil && currentUntil.toMillis() > now.toMillis() ?
        currentUntil :
        now;
    const referrerUntil = Timestamp.fromMillis(
      base.toMillis() + REWARD_DAYS * 86400 * 1000,
    );

    // Al invitado solo se le marca como referido — conserva sus anuncios.
    tx.update(inviteeRef, {referredBy: referrerId});
    tx.set(edgeRef, {referrerId, inviteeId: uid, createdAt: now});
    // Solo quien invita se queda sin anuncios (la ventana se acumula).
    tx.update(referrerRef, {
      referralCount: FieldValue.increment(1),
      adsFreeUntil: referrerUntil,
    });
  });

  return {ok: true};
});
