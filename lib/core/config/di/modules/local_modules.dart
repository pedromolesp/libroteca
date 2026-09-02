part of '../dependency_injector.dart';

Future<void> _localModulesInit() async {
  getIt.registerSingleton<SharedPreferencesService>(
    await SharedPreferencesService.ensureInitialized(),
  );
  getIt.registerLazySingleton(BookLocalDataSource.new);
  getIt.registerLazySingleton(GoogleBooksApi.new);
  getIt.registerLazySingleton(AdsService.new);
}
