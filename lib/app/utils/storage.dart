import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Storage {
  
  static Future<bool> initSessionManager() async {
    var _prefs = await SharedPreferences.getInstance();
    Get.put(_prefs);
    return true;
  }

  get(key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }

  static getNotAsync(key) {
    SharedPreferences sharedPreferences = Get.find();
    return sharedPreferences.get(key);
  }

  getDouble(key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(key);
  }

  put(key, val) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (val is bool == true) {
      return sharedPreferences.setBool(key, val);
    } else if (val is String == true) {
      return sharedPreferences.setString(key, val);
    } else if (val is int == true) {
      return sharedPreferences.setInt(key, val);
    } else if (val is double == true) {
      return sharedPreferences.setDouble(key, val);
    } else if (val is List == true) {
      return sharedPreferences.setString(key, val);
    }
  }

  remove(key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(key);
  }

  exists(key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      return sharedPreferences.containsKey(key);
    } catch (ex) {
      return false;
    }
  }

  clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.clear();
  }
}
