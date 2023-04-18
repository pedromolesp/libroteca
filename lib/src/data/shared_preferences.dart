import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instancia = new Preferences._internal();

  factory Preferences() {
    return _instancia;
  }

  Preferences._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  List<String> get chosenPrimaryColor {
    List<String> list = _prefs.getStringList('chosen-primary-color')!;

    return list;
  }

  set chosenPrimaryColor(List<String> value) {
    _prefs.setStringList('chosen-primary-color', value);
  }
}
