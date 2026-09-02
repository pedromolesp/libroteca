// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tomora';

  @override
  String get tabLibrary => 'Mi biblioteca';

  @override
  String get tabRated => 'Valorados';

  @override
  String get tabPreferences => 'Preferencias';

  @override
  String get searchBookHint => 'Busca un libro';

  @override
  String get emptyLibrary => 'Aún no has añadido ningún libro';

  @override
  String get addBook => 'Añadir libro';

  @override
  String get editBook => 'Editar libro';
}
