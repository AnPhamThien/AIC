import 'package:imagecaptioning/src/model/category/category.dart';

import 'base_prefs.dart';

class AppPref extends BasePrefs {
  static Future<AppPref> instance() async {
    final _appPref = AppPref();
    await _appPref.init();
    return _appPref;
  }

  String get getToken {
    return getValueForKey(PrefKey.token) ?? '';
  }

  Future<void> setToken(String token) {
    return setValueForKey(PrefKey.token, token);
  }

  String get getUserID {
    return getValueForKey(PrefKey.userID) ?? '';
  }

  Future<void> setUserID(String userID) {
    return setValueForKey(PrefKey.userID, userID);
  }

  String get getUsername {
    return getValueForKey(PrefKey.username) ?? '';
  }

  Future<void> setUsername(String username) {
    return setValueForKey(PrefKey.username, username);
  }

  String get getRefreshToken {
    return getValueForKey(PrefKey.refreshToken) ?? '';
  }

  Future<void> setRefreshToken(String userID) {
    return setValueForKey(PrefKey.refreshToken, userID);
  }

  String get getAvatarPath {
    return getValueForKey(PrefKey.avatarPath) ?? '';
  }

  Future<void> setAvatarPath(String avatarPath) {
    return setValueForKey(PrefKey.avatarPath, avatarPath);
  }

  List<Category> get getCategory{
    return getValueForKey(PrefKey.categoryList);
  }
}

class PrefKey {
  static const String token = 'TOKEN';
  static const String userID = 'ID';
  static const String username = 'USERNAME';
  static const String refreshToken = 'REFRESHTOKEN';
  static const String avatarPath = 'AVATARPATH';
  static const String categoryList = 'CATEGORYLIST';
}
