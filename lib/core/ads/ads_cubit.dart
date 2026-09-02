import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/features/auth/data/users_repository.dart';
import 'package:tomora/features/auth/domain/model/user_profile.dart';

/// Si este usuario debe ver anuncios ahora mismo.
///
/// Lo decide el perfil del usuario: una invitación canjeada extiende
/// `adsFreeUntil` (ver la función `redeemReferral`) y los anuncios vuelven
/// solos cuando esa fecha pasa.
///
/// Sin backend Firebase (`firebaseReady == false`) se construye con
/// [AdsCubit.disabled], que mantiene los anuncios ocultos hasta que haya
/// backend.
class AdsState {
  const AdsState({this.adsEnabled = true});

  final bool adsEnabled;

  AdsState copyWith({bool? adsEnabled}) =>
      AdsState(adsEnabled: adsEnabled ?? this.adsEnabled);
}

class AdsCubit extends Cubit<AdsState> {
  AdsCubit({
    required UsersRepository usersRepository,
    FirebaseAuth? auth,
  })  : _usersRepository = usersRepository,
        _auth = auth ?? FirebaseAuth.instance,
        super(const AdsState()) {
    _authSubscription = _auth!.authStateChanges().listen(_onAuthChanged);
  }

  /// Variante inerte para cuando no hay backend: anuncios siempre ocultos.
  AdsCubit.disabled()
      : _usersRepository = null,
        _auth = null,
        super(const AdsState(adsEnabled: false));

  final UsersRepository? _usersRepository;
  final FirebaseAuth? _auth;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<UserProfile?>? _profileSubscription;
  Timer? _expiryTimer;

  void _onAuthChanged(User? user) {
    _profileSubscription?.cancel();
    _expiryTimer?.cancel();
    if (user == null) {
      _set(true);
      return;
    }
    _profileSubscription =
        _usersRepository!.watchProfile(user.uid).listen(_onProfile);
  }

  void _onProfile(UserProfile? profile) {
    _expiryTimer?.cancel();
    final until = profile?.adsFreeUntil;
    if (until == null || !until.isAfter(DateTime.now())) {
      _set(true);
      return;
    }
    _set(false);
    // Vuelve a activar los anuncios en cuanto acaba la ventana sin anuncios.
    _expiryTimer = Timer(until.difference(DateTime.now()), () => _set(true));
  }

  void _set(bool adsEnabled) {
    if (!isClosed && adsEnabled != state.adsEnabled) {
      emit(state.copyWith(adsEnabled: adsEnabled));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    _expiryTimer?.cancel();
    return super.close();
  }
}
