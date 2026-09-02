import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:tomora/core/config/di/dependency_injector.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_state.dart';
import 'package:tomora/features/auth/presentation/login_screen.dart';
import 'package:tomora/features/auth/presentation/register_screen.dart';
import 'package:tomora/features/library/domain/model/book.dart';
import 'package:tomora/features/library/presentation/book_detail_screen.dart';
import 'package:tomora/features/library/presentation/book_form_screen.dart';
import 'package:tomora/features/library/presentation/library_screen.dart';
import 'package:tomora/features/splash/presentation/loading_screen.dart';

/// Puente entre el stream de [AuthCubit] y `refreshListenable` de go_router:
/// cada cambio de sesión hace que el router reevalúe `redirect`.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Stream<AuthState> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

abstract final class RouteNames {
  static const loading = 'loading';
  static const library = 'library';
  static const bookNew = 'book-new';
  static const bookDetail = 'book-detail';
  static const bookEdit = 'book-edit';
  static const login = 'login';
  static const register = 'register';
}

/// Rutas que se pueden ver sin sesión iniciada. Todo lo demás (la biblioteca y
/// las fichas de libro) exige estar autenticado — Tomora es "login primero".
const _publicPaths = {'/loading', '/login', '/register'};

final goRouter = GoRouter(
  initialLocation: '/loading',
  // Rehace la evaluación de `redirect` cuando cambia el estado de sesión, para
  // que al iniciar/cerrar sesión el router salte solo a la pantalla correcta.
  refreshListenable: _AuthRefreshNotifier(getIt<AuthCubit>().stream),
  redirect: (context, state) {
    final auth = getIt<AuthCubit>();

    // Sin backend Firebase no hay forma de autenticar; se deja pasar para que
    // la app siga usable en "modo offline" con la biblioteca local.
    if (!auth.isEnabled) return null;

    final loggedIn = auth.state.isAuthenticated;
    final atPublic = _publicPaths.contains(state.matchedLocation);

    // La pantalla de carga decide a dónde ir; no la interceptamos.
    if (state.matchedLocation == '/loading') return null;

    if (!loggedIn && !atPublic) return '/login';
    if (loggedIn && (state.matchedLocation == '/login' ||
        state.matchedLocation == '/register')) {
      return '/library';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/loading',
      name: RouteNames.loading,
      builder: (_, __) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/library',
      name: RouteNames.library,
      builder: (_, __) => const LibraryScreen(),
    ),
    GoRoute(
      path: '/book/new',
      name: RouteNames.bookNew,
      builder: (_, state) => BookFormScreen(book: state.extra as Book?),
    ),
    GoRoute(
      path: '/book/:id/edit',
      name: RouteNames.bookEdit,
      builder: (_, state) => BookFormScreen(book: state.extra as Book?),
    ),
    GoRoute(
      path: '/book/:id',
      name: RouteNames.bookDetail,
      builder: (_, state) => BookDetailScreen(book: state.extra as Book?),
    ),
    GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: RouteNames.register,
      builder: (_, __) => const RegisterScreen(),
    ),
  ],
);
