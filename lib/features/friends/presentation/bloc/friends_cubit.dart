import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/features/friends/data/friends_repository.dart';
import 'package:tomora/features/friends/domain/model/friend.dart';

class FriendsState {
  const FriendsState({
    this.friends = const [],
    this.loading = true,
    this.working = false,
  });

  final List<Friend> friends;

  /// Cargando la lista por primera vez.
  final bool loading;

  /// Hay un añadir/eliminar en curso.
  final bool working;

  FriendsState copyWith({
    List<Friend>? friends,
    bool? loading,
    bool? working,
  }) {
    return FriendsState(
      friends: friends ?? this.friends,
      loading: loading ?? this.loading,
      working: working ?? this.working,
    );
  }
}

/// Lista de amigos del usuario con sesión y las acciones de añadir/eliminar.
/// App-wide (vive bajo `TopBlocProviders`) para que la insignia y la pantalla
/// compartan estado. Sin backend se construye con [FriendsCubit.disabled].
class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit({
    required FriendsRepository repository,
    FirebaseAuth? auth,
  })  : _repository = repository,
        _auth = auth ?? FirebaseAuth.instance,
        super(const FriendsState()) {
    _authSub = _auth!.authStateChanges().listen(_onAuthChanged);
  }

  FriendsCubit.disabled()
      : _repository = null,
        _auth = null,
        super(const FriendsState(loading: false));

  final FriendsRepository? _repository;
  final FirebaseAuth? _auth;
  StreamSubscription<User?>? _authSub;
  StreamSubscription<List<Friend>>? _friendsSub;

  void _onAuthChanged(User? user) {
    _friendsSub?.cancel();
    _friendsSub = null;
    if (user == null || _repository == null) {
      emit(const FriendsState(loading: false));
      return;
    }
    emit(state.copyWith(loading: true));
    _friendsSub = _repository.watchFriends(user.uid).listen(
          (friends) => emit(state.copyWith(friends: friends, loading: false)),
          onError: (_) => emit(state.copyWith(loading: false)),
        );
  }

  Future<AddFriendResult> addByCode(String code) async {
    final uid = _auth?.currentUser?.uid;
    if (_repository == null || uid == null) return AddFriendResult.failed;
    emit(state.copyWith(working: true));
    final result = await _repository.addFriendByCode(uid, code);
    emit(state.copyWith(working: false));
    return result;
  }

  Future<bool> remove(Friend friend) async {
    if (_repository == null) return false;
    emit(state.copyWith(working: true));
    final ok = await _repository.removeFriend(friend.connectionId);
    emit(state.copyWith(working: false));
    return ok;
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    _friendsSub?.cancel();
    return super.close();
  }
}
