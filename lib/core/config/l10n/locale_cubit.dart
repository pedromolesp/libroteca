import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/core/storage/shared_preferences_service.dart';

/// Idioma elegido por el usuario, persistido en `SharedPreferences`.
///
/// El estado es un [Locale] nullable: `null` significa "seguir al sistema"
/// (`MaterialApp` resolverá contra `supportedLocales`).
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit(this._prefs) : super(_localeFromCode(_prefs.languageCode));

  final SharedPreferencesService _prefs;

  /// Idiomas que ofrece el selector, además de "idioma del sistema".
  static const supported = [Locale('es'), Locale('en'), Locale('de')];

  static Locale? _localeFromCode(String? code) =>
      code == null ? null : Locale(code);

  /// [locale] `null` -> volver al idioma del sistema.
  Future<void> setLocale(Locale? locale) async {
    await _prefs.setLanguageCode(locale?.languageCode);
    emit(locale);
  }
}
