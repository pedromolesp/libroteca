import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/features/auth/data/users_repository.dart';
import 'package:tomora/features/auth/domain/model/user_profile.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_state.dart';

/// Envuelve Firebase Authentication (email/contraseña). El SDK de Firebase
/// persiste la sesión entre reinicios, así que [FirebaseAuth.authStateChanges]
/// es la única fuente de verdad.
///
/// Sin backend Firebase se construye con [AuthCubit.disabled], que se queda en
/// [AuthState.initial] y deja las acciones como no-op.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required UsersRepository usersRepository,
    FirebaseAuth? auth,
  })  : _usersRepository = usersRepository,
        _auth = auth ?? FirebaseAuth.instance,
        _enabled = true,
        super(AuthState.initial) {
    _authSubscription = _auth!.authStateChanges().listen(_onAuthStateChanged);
  }

  AuthCubit.disabled()
      : _usersRepository = null,
        _auth = null,
        _enabled = false,
        super(AuthState.initial);

  final UsersRepository? _usersRepository;
  final FirebaseAuth? _auth;
  final bool _enabled;
  StreamSubscription<User?>? _authSubscription;

  bool get isEnabled => _enabled;

  void _onAuthStateChanged(User? user) => emit(_stateFor(user));

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

  /// Devuelve `null` si va bien, o un [FirebaseAuthException.code] para mostrar.
  Future<String?> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (!_enabled) return 'operation-not-allowed';
    try {
      final trimmedEmail = email.trim();
      final trimmedName = displayName.trim();
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
      await credential.user?.updateDisplayName(trimmedName);

      final uid = credential.user?.uid;
      if (uid != null) {
        final referralCode = await _usersRepository!.claimReferralCode(uid);
        await _usersRepository.upsertProfile(
          UserProfile(
            uid: uid,
            email: trimmedEmail,
            displayName: trimmedName,
            referralCode: referralCode,
          ),
        );
      }

      // updateDisplayName no siempre redispara authStateChanges.
      emit(_stateFor(_auth.currentUser));
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> logout() => _enabled ? _auth!.signOut() : Future.value();

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
