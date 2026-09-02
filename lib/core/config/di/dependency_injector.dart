import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:tomora/core/ads/ads_cubit.dart';
import 'package:tomora/core/ads/ads_service.dart';
import 'package:tomora/core/storage/shared_preferences_service.dart';
import 'package:tomora/features/auth/data/referral_repository.dart';
import 'package:tomora/features/auth/data/users_repository.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:tomora/features/auth/presentation/bloc/referral_cubit.dart';
import 'package:tomora/features/catalog/data/google_books_api.dart';
import 'package:tomora/features/catalog/presentation/bloc/book_search_cubit.dart';
import 'package:tomora/features/library/data/book_local_datasource.dart';
import 'package:tomora/features/library/data/book_repository.dart';
import 'package:tomora/features/library/presentation/bloc/library_cubit.dart';
import 'package:tomora/features/preferences/data/library_backup_service.dart';

part 'modules/local_modules.dart';
part 'modules/remote_modules.dart';
part 'modules/repository_modules.dart';
part 'modules/ui_modules.dart';

final getIt = GetIt.instance;

/// `firebaseReady` viene de [bootstrapFirebase]. Cuando es `false` (todavía no
/// se ejecutó `flutterfire configure`) se registran variantes inertes de los
/// cubits que dependen de Firebase y se omiten los repos remotos.
Future<void> initDi({required bool firebaseReady}) async {
  await _localModulesInit();
  _remoteModulesInit(firebaseReady: firebaseReady);
  _repositoryModulesInit(firebaseReady: firebaseReady);
  _uiModulesInit(firebaseReady: firebaseReady);
}
