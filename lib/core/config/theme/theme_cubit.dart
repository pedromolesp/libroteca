import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/core/storage/shared_preferences_service.dart';

/// Tema elegido por el usuario (claro / oscuro / el del sistema), persistido
/// en `SharedPreferences`. `ThemeMode.system` (el valor por defecto) hace que
/// seguir al tema del dispositivo.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(_fromName(_prefs.themeModeName));

  final SharedPreferencesService _prefs;

  static ThemeMode _fromName(String? name) => switch (name) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setThemeModeName(mode == ThemeMode.system ? null : mode.name);
    emit(mode);
  }
}
