import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  late final SharedPreferences _sharedPreferences;

  Future<void> initPref() async => _sharedPreferences = await SharedPreferences.getInstance();

  Future<void> saveString({required String key, required String value}) async {
    await _sharedPreferences.setString(key, value);
  }
}
