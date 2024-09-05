import 'dart:developer';

import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';

class SessionManager {
  Future<void> updateLastLoggedInTimeAndLoggedInStatus() async {
    final currentTime = DateTime.now();
    await StorageUtil.putString(localStorageData.ISLOGGEDIN, "TRUE");
    await StorageUtil.putString(
        localStorageData.LASTLOGGEDINTIME, currentTime.toIso8601String());

    var loginStatus = StorageUtil.getString(localStorageData.ISLOGGEDIN);
    var loggedTime = StorageUtil.getString(localStorageData.LASTLOGGEDINTIME);

    log('islogged: $loginStatus --- loggedONTIME: $loggedTime');
  }

  Future<void> logout() async {
    await StorageUtil.remove(localStorageData.ISLOGGEDIN);
    await StorageUtil.remove(localStorageData.LASTLOGGEDINTIME);
  }

  void updateLoggedInTimeAndLoggedStatus() {}
}

SessionManager sessionManager = SessionManager();
