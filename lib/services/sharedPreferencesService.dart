import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService();

  Future<bool> saveStringData(nameKey, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return await preferences.setString(nameKey, value);
  }

  Future<bool> saveDoubleData(nameKey, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return await preferences.setDouble(nameKey, value);
  }

  Future<String> loadStringData(nameKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString(nameKey) ?? '';
  }

  Future<double> loadDoubleData(nameKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getDouble(nameKey) ?? 0.0;
  }
}
