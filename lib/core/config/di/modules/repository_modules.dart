part of '../dependency_injector.dart';

void _repositoryModulesInit({required bool firebaseReady}) {
  // Biblioteca: implementación local sqflite (destino: FirestoreBookRepository).
  getIt.registerLazySingleton<BookRepository>(
    () => LocalBookRepository(getIt<BookLocalDataSource>()),
  );
  getIt.registerLazySingleton(
    () => LibraryBackupService(getIt<BookRepository>()),
  );

  if (firebaseReady) {
    getIt.registerLazySingleton(
      () => UsersRepository(firestore: getIt<FirebaseFirestore>()),
    );
    getIt.registerLazySingleton(
      () => ReferralRepository(functions: getIt<FirebaseFunctions>()),
    );
    getIt.registerLazySingleton(
      () => FriendsRepository(firestore: getIt<FirebaseFirestore>()),
    );
  }
}
