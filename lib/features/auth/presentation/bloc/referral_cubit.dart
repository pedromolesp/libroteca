import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/features/auth/data/referral_repository.dart';
import 'package:tomora/features/auth/data/users_repository.dart';
import 'package:tomora/features/auth/domain/model/user_profile.dart';

class ReferralState {
  const ReferralState({this.profile, this.redeeming = false});

  /// El perfil del usuario con sesión (código, nº de invitados, ad-free until),
  /// o `null` antes de cargar / sin sesión.
  final UserProfile? profile;

  /// Hay una llamada de canje en curso.
  final bool redeeming;

  ReferralState copyWith({UserProfile? profile, bool? redeeming}) {
    return ReferralState(
      profile: profile ?? this.profile,
      redeeming: redeeming ?? this.redeeming,
    );
  }
}

/// Respalda la tarjeta "invita a un amigo, quítate los anuncios": expone el
/// código propio y sus estadísticas (del perfil) y la acción de canje.
///
/// Sin backend se construye con [ReferralCubit.disabled].
class ReferralCubit extends Cubit<ReferralState> {
  ReferralCubit({
    required UsersRepository usersRepository,
    required ReferralRepository referralRepository,
    FirebaseAuth? auth,
  })  : _usersRepository = usersRepository,
        _referralRepository = referralRepository,
        _auth = auth ?? FirebaseAuth.instance,
        super(const ReferralState()) {
    _authSubscription = _auth!.authStateChanges().listen(_onAuthChanged);
  }

  ReferralCubit.disabled()
      : _usersRepository = null,
        _referralRepository = null,
        _auth = null,
        super(const ReferralState());

  final UsersRepository? _usersRepository;
  final ReferralRepository? _referralRepository;
  final FirebaseAuth? _auth;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<UserProfile?>? _profileSubscription;

  void _onAuthChanged(User? user) {
    _profileSubscription?.cancel();
    if (user == null) {
      emit(const ReferralState());
      return;
    }
    _profileSubscription = _usersRepository!
        .watchProfile(user.uid)
        .listen((profile) => emit(state.copyWith(profile: profile)));
  }

  Future<RedeemResult> redeem(String code) async {
    if (_referralRepository == null) return RedeemResult.failed;
    emit(state.copyWith(redeeming: true));
    final result = await _referralRepository.redeem(code);
    emit(state.copyWith(redeeming: false));
    return result;
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    return super.close();
  }
}
