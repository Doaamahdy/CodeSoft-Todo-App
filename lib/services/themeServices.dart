import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final _storage = GetStorage();
  final _key = "isDark";

  _saveTheme(bool isDark) {
    _storage.write(_key, isDark);
  }

  bool _loadTheme() => _storage.read(_key) ?? false;
  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;
  void switchThemes() {
    Get.changeThemeMode(_loadTheme() ? ThemeMode.light : ThemeMode.dark);
    _saveTheme(!_loadTheme());
  }
}
