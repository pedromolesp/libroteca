import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/features/friends/data/friends_repository.dart';
import 'package:tomora/features/friends/domain/model/friend.dart';

class FriendsState {
  const FriendsState({
    this.friends = const [],
    this.incomingRequests = const [],
    this.outgoingRequests = const [],
    this.loading = true,
    this.working = false,
    this.error = false,
  });

  /// Amistades aceptadas.
  final List<Friend> friends;

  /// Solicitudes que otras personas te han enviado, pendientes de tu respuesta.
  final List<Friend> incomingRequests;

  /// Solicitudes que tú has enviado, pendientes de que las acepten.
  final List<Friend> outgoingRequests;

  /// Cargando la lista por primera vez.
  final bool loading;

  /// Hay un añadir/responder/eliminar en curso.
  final bool working;

  /// El stream de conexiones falló (p. ej. reglas sin desplegar).
  final bool error;

  FriendsState copyWith({
    List<Friend>? friends,
    List<Friend>? incomingRequests,
    List<Friend>? outgoingRequests,
    bool? loading,
    bool? working,
    bool? error,
  }) {
    return FriendsState(
      friends: friends ?? this.friends,
      incomingRequests: incomingRequests ?? this.incomingRequests,
      outgoingRequests: outgoingRequests ?? this.outgoingRequests,
      loading: loading ?? this.loading,
      working: working ?? this.working,
      error: error ?? false,
    );
  }
}

/// Lista de amigos y solicitudes del usuario con sesión, y las acciones de
/// añadir/responder/eliminar. App-wide (vive bajo `TopBlocProviders`) para que
/// la insignia y la pantalla compartan estado. Sin backend se construye con
/// [FriendsCubit.disabled].
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
  StreamSubscription<List<Friend>>? _connectionsSub;

  void _onAuthChanged(User? user) {
    _connectionsSub?.cancel();
    _connectionsSub = null;
    if (user == null || _repository == null) {
      emit(const FriendsState(loading: false));
      return;
    }
    emit(state.copyWith(loading: true));
    _connectionsSub = _repository.watchConnections(user.uid).listen(
      (connections) {
        emit(state.copyWith(
          friends: connections
              .where((c) => c.status == ConnectionStatus.accepted)
              .toList(),
          incomingRequests: connections
              .where((c) => c.isPending && !c.requestedByMe)
              .toList(),
          outgoingRequests:
              connections.where((c) => c.isPending && c.requestedByMe).toList(),
          loading: false,
        ));
      },
      onError: (_) => emit(state.copyWith(loading: false, error: true)),
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

  Future<bool> respond(Friend request, {required bool accept}) async {
    if (_repository == null) return false;
    emit(state.copyWith(working: true));
    final ok = await _repository.respondToRequest(request.connectionId,
        accept: accept);
    emit(state.copyWith(working: false));
    return ok;
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
    _connectionsSub?.cancel();
    return super.close();
  }
}
