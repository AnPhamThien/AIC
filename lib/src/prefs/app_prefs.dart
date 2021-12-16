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

  String get getRefreshToken {
    return getValueForKey(PrefKey.refreshToken) ?? '';
  }

  Future<void> setRefreshToken(String userID) {
    return setValueForKey(PrefKey.refreshToken, userID);
  }
}

class PrefKey {
  static const String token = 'TOKEN';
  static const String userID = 'ID';
  static const String refreshToken = 'REFRESHTOKEN';
}
