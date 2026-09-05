import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tomora/features/auth/data/account_repository.dart';
import 'package:tomora/features/auth/data/users_repository.dart';
import 'package:tomora/features/auth/domain/model/user_profile.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_state.dart';

/// Envuelve Firebase Authentication (email/contraseña). El SDK de Firebase
/// persiste la sesión entre reinicios, así que [FirebaseAuth.authStateChanges]
/// es la única fuente de verdad.
///
/// En cada sesión iniciada garantiza que existe el documento `users/{uid}` en
/// Firestore (ver [UsersRepository.ensureProfile]): una cuenta puede existir en
/// Auth pero no en Firestore si el registro falló a medias o si es el primer
/// login en otro dispositivo, y sin ese documento no funcionan los referidos ni
/// los datos de usuario.
///
/// Sin backend Firebase se construye con [AuthCubit.disabled], que se queda en
/// [AuthState.initial] y deja las acciones como no-op.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required UsersRepository usersRepository,
    required AccountRepository accountRepository,
    FirebaseAuth? auth,
  })  : _usersRepository = usersRepository,
        _accountRepository = accountRepository,
        _auth = auth ?? FirebaseAuth.instance,
        _enabled = true,
        super(AuthState.initial) {
    _authSubscription = _auth!.authStateChanges().listen(_onAuthStateChanged);
  }

  AuthCubit.disabled()
      : _usersRepository = null,
        _accountRepository = null,
        _auth = null,
        _enabled = false,
        super(AuthState.initial);

  final UsersRepository? _usersRepository;
  final AccountRepository? _accountRepository;
  final FirebaseAuth? _auth;
  final bool _enabled;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<UserProfile?>? _profileSubscription;

  /// `true` mientras [register] está en curso, para que [_onAuthStateChanged]
  /// no cree el perfil en paralelo (lo hace `register` con el nombre ya puesto).
  bool _registering = false;

  bool _googleReady = false;

  bool get isEnabled => _enabled;

  Future<void> _onAuthStateChanged(User? user) async {
    _profileSubscription?.cancel();
    _profileSubscription = null;

    emit(_stateFor(user));
    if (user == null || _usersRepository == null || _registering) return;

    // Autorreparación: si la cuenta no tiene perfil en Firestore, se crea.
    try {
      await _usersRepository.ensureProfile(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
      );
    } catch (e) {
      // No rompe la sesión; se reintenta en el próximo arranque.
      if (kDebugMode) debugPrint('ensureProfile falló: $e');
    }

    // `user.displayName` suele venir null en este evento (solo se rellena tras
    // un refresco de token); el perfil de Firestore es el nombre fiable.
    _profileSubscription =
        _usersRepository.watchProfile(user.uid).listen((profile) {
      final name = profile?.displayName;
      if (name != null && name.isNotEmpty && name != state.displayName) {
        emit(state.copyWith(displayName: name));
      }
    });
  }

  AuthState _stateFor(User? user) {
    if (user == null) return AuthState.initial;
    return AuthState(
      isAuthenticated: true,
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  /// Devuelve `null` si va bien, o un [FirebaseAuthException.code] para mostrar.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    if (!_enabled) return 'operation-not-allowed';
    try {
      await _auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  /// Envía el correo de restablecimiento de contraseña. Devuelve `null` si va
  /// bien, o un [FirebaseAuthException.code] para mostrar.
  Future<String?> sendPasswordReset(String email) async {
    if (!_enabled) return 'operation-not-allowed';
    try {
      await _auth!.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  /// Devuelve `null` si va bien, o un [FirebaseAuthException.code] para mostrar.
  ///
  /// Crea la cuenta en Auth y su documento `users/{uid}` en Firestore. Si la
  /// escritura en Firestore falla (reglas sin desplegar, sin red...), la cuenta
  /// de Auth ya existe y el registro se considera correcto — el perfil se
  /// reintenta solo en el siguiente arranque desde [_onAuthStateChanged].
  Future<String?> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (!_enabled) return 'operation-not-allowed';
    final trimmedEmail = email.trim();
    final trimmedName = displayName.trim();
    _registering = true;
    try {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
      final user = credential.user;
      await user?.updateDisplayName(trimmedName);

      if (user != null) {
        try {
          await _usersRepository!.ensureProfile(
            uid: user.uid,
            email: trimmedEmail,
            displayName: trimmedName,
          );
        } on FirebaseException catch (e) {
          if (kDebugMode) {
            debugPrint(
                'perfil no creado (${e.code}); se reintentará al arrancar');
          }
        }
      }

      // updateDisplayName no siempre redispara authStateChanges.
      emit(_stateFor(_auth.currentUser));
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } finally {
      _registering = false;
    }
  }

  /// Inicia sesión con Google (Google Sign-In → credencial de Firebase). El
  /// documento `users/{uid}` lo crea [_onAuthStateChanged] igual que en el
  /// resto de accesos. Devuelve `null` si va bien (o si el usuario cancela),
  /// o un código de error para [authErrorMessage].
  Future<String?> signInWithGoogle() async {
    if (!_enabled) return 'operation-not-allowed';
    try {
      if (!_googleReady) {
        await GoogleSignIn.instance.initialize();
        _googleReady = true;
      }
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        return 'google-sign-in-failed';
      }
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) return 'google-sign-in-failed';

      await _auth!.signInWithCredential(
        GoogleAuthProvider.credential(idToken: idToken),
      );
      return null;
    } on GoogleSignInException catch (e) {
      // Cancelar no es un error: no se muestra nada.
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      if (kDebugMode) debugPrint('Google Sign-In falló: $e');
      return 'google-sign-in-failed';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> logout() async {
    if (!_enabled) return;
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Google no inicializado / sin sesión de Google: no pasa nada.
    }
    await _auth!.signOut();
  }

  /// Borra permanentemente la cuenta (Auth + perfil + amistades + código de
  /// invitación) vía la Cloud Function `deleteAccount`, y cierra sesión
  /// localmente. `true` si se completó.
  Future<bool> deleteAccount() async {
    if (!_enabled) return false;
    final ok = await _accountRepository!.deleteAccount();
    if (ok) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Google no inicializado / sin sesión de Google: no pasa nada.
      }
      // El usuario ya no existe en el servidor; esto limpia la sesión local
      // sin esperar a que el SDK lo detecte solo en el próximo refresco.
      await _auth!.signOut();
    }
    return ok;
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    return super.close();
  }
}
