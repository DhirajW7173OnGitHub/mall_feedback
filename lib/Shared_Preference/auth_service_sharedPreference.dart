import 'dart:developer';

import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';

class SessionManager {
  Future<void> updateLastLoggedInTimeAndLoggedInStatus() async {
    final currentTime = DateTime.now();
    await StorageUtil.putString(LocalStorageData.ISLOGGEDIN, "TRUE");
    await StorageUtil.putString(
        LocalStorageData.LASTLOGGEDINTIME, currentTime.toIso8601String());

    var loginStatus = StorageUtil.getString(LocalStorageData.ISLOGGEDIN);
    var loggedTime = StorageUtil.getString(LocalStorageData.LASTLOGGEDINTIME);

    log('islogged: $loginStatus --- loggedONTIME: $loggedTime');
  }

  Future<void> logout() async {
    await StorageUtil.remove(LocalStorageData.ISLOGGEDIN);
    await StorageUtil.remove(LocalStorageData.LASTLOGGEDINTIME);
  }

  void updateLoggedInTimeAndLoggedStatus() {}
}

SessionManager sessionManager = SessionManager();
