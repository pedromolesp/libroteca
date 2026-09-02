import 'package:shared_preferences/shared_preferences.dart';

/// Acceso tipado a `SharedPreferences`. Reemplaza al antiguo singleton
/// `Preferences`, que hacía `late` sin inicializar y `getStringList(...)!`
/// (NPE si la clave no existía).
///
/// Se registra en el DI como singleton, tras llamar a [ensureInitialized] en
/// el arranque.
class SharedPreferencesService {
  SharedPreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static Future<SharedPreferencesService> ensureInitialized() async {
    return SharedPreferencesService(await SharedPreferences.getInstance());
  }

  static const _kChosenPrimaryColor = 'chosen-primary-color';

  List<String> get chosenPrimaryColor =>
      _prefs.getStringList(_kChosenPrimaryColor) ?? const [];

  Future<void> setChosenPrimaryColor(List<String> value) =>
      _prefs.setStringList(_kChosenPrimaryColor, value);
}
