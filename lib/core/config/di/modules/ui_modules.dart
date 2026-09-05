part of '../dependency_injector.dart';

void _uiModulesInit({required bool firebaseReady}) {
  // Idioma y tema elegidos (persistidos). App-wide, bajo TopBlocProviders.
  getIt.registerLazySingleton(
    () => LocaleCubit(getIt<SharedPreferencesService>()),
  );
  getIt.registerLazySingleton(
    () => ThemeCubit(getIt<SharedPreferencesService>()),
  );

  // Cubits por pantalla (instancia nueva cada vez).
  getIt.registerFactory(() => LibraryCubit(getIt<BookRepository>()));
  getIt.registerFactory(() => BookSearchCubit(getIt<GoogleBooksApi>()));

  // Cubits de app (viven bajo TopBlocProviders). Con backend escuchan
  // FirebaseAuth; sin backend son variantes inertes.
  if (firebaseReady) {
    getIt.registerLazySingleton(
      () => AuthCubit(
        usersRepository: getIt<UsersRepository>(),
        accountRepository: getIt<AccountRepository>(),
        auth: getIt<FirebaseAuth>(),
      ),
    );
    getIt.registerLazySingleton(
      () => ReferralCubit(
        usersRepository: getIt<UsersRepository>(),
        referralRepository: getIt<ReferralRepository>(),
        auth: getIt<FirebaseAuth>(),
      ),
    );
    getIt.registerLazySingleton(
      () => AdsCubit(
        usersRepository: getIt<UsersRepository>(),
        auth: getIt<FirebaseAuth>(),
      ),
    );
    getIt.registerLazySingleton(
      () => FriendsCubit(
        repository: getIt<FriendsRepository>(),
        auth: getIt<FirebaseAuth>(),
      ),
    );
  } else {
    getIt.registerLazySingleton(AuthCubit.disabled);
    getIt.registerLazySingleton(ReferralCubit.disabled);
    getIt.registerLazySingleton(AdsCubit.disabled);
    getIt.registerLazySingleton(FriendsCubit.disabled);
  }
}
