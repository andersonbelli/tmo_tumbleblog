import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<bool> writeData(String id, String data) async {
    try {
      return (await _prefs).setString(id, data);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> retrieveSingleData(String id) async => (await _prefs).getString(id);

  Future<Map<String, dynamic>> retrieveData() async {
    final prefs = (await _prefs);

    Set<String> keys = prefs.getKeys();
    Map<String, dynamic> data = {};

    for (var key in keys) {
      if (prefs.containsKey(key)) {
        dynamic value = prefs.get(key);
        data[key] = value;
      }
    }

    return data;
  }
}
