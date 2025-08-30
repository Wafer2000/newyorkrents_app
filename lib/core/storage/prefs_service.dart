import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _kLastHandle = 'last_handle';
  static const _kLastFilterInputs = 'last_filter_inputs';

  final SharedPreferences _prefs;
  PrefsService(this._prefs);

  String? get lastHandle => _prefs.getString(_kLastHandle);
  Future<void> setLastHandle(String h) => _prefs.setString(_kLastHandle, h);

  String? get lastFilterInputs => _prefs.getString(_kLastFilterInputs);
  Future<void> setLastFilterInputs(String json) => _prefs.setString(_kLastFilterInputs, json);
}
