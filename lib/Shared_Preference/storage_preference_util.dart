import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static final StorageUtil _instance = StorageUtil._();
  static SharedPreferences? _preferences;

  StorageUtil._();

  static Future<StorageUtil> getInstance() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  // get string
  static String getString(String key, {String defValue = ''}) {
    return _preferences?.getString(key) ?? defValue;
  }

  // put string
  static Future<bool> putString(String key, String value) async {
    return _preferences?.setString(key, value) ?? Future.value(false);
  }

  // get bool
  static bool getBool(String key, {bool defValue = false}) {
    return _preferences?.getBool(key) ?? defValue;
  }

  // put bool
  static Future<bool> putBool(String key, bool value) async {
    return _preferences?.setBool(key, value) ?? Future.value(false);
  }

  // get int
  static int getInt(String key, {int defValue = 0}) {
    return _preferences?.getInt(key) ?? defValue;
  }

  // put int
  static Future<bool> putInt(String key, int value) async {
    return _preferences?.setInt(key, value) ?? Future.value(false);
  }

  // get double
  static double getDouble(String key, {double defValue = 0.0}) {
    return _preferences?.getDouble(key) ?? defValue;
  }

  // put double
  static Future<bool> putDouble(String key, double value) async {
    return _preferences?.setDouble(key, value) ?? Future.value(false);
  }

  // get string list
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    return _preferences?.getStringList(key) ?? defValue;
  }

  // put string list
  static Future<bool> putStringList(String key, List<String> value) async {
    return _preferences?.setStringList(key, value) ?? Future.value(false);
  }

  // Remove a specific key
  static Future<bool> remove(String key) async {
    return _preferences?.remove(key) ?? Future.value(false);
  }

  // clear all preferences
  static Future<bool> clearAll() async {
    return _preferences?.clear() ?? Future.value(false);
  }
}
