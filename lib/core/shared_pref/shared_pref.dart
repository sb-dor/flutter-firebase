import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  late final SharedPreferences _sharedPreferences;

  Future<void> initPref() async => _sharedPreferences = await SharedPreferences.getInstance();

  Future<void> saveString({required String key, required String value}) async {
    await _sharedPreferences.setString(key, value);
  }

  Future<void> saveInt({required String key, required int value}) async {
    await _sharedPreferences.setInt(key, value);
  }

  Future<void> deleteByKey({required String key}) async {
    _sharedPreferences.remove(key);
  }

  String? getStringByKey({required String key}) {
    return _sharedPreferences.getString(key);
  }

  int? getIntByKey({required String key}) {
    return _sharedPreferences.getInt(key);
  }
}
