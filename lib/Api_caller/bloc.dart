import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mall_app/Api_caller/api_caller.dart';
import 'package:mall_app/Model/login_user_model.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/global_utils.dart';
import 'package:mall_app/feedback/Model/feedback_model.dart';
import 'package:rxdart/rxdart.dart';

class GlobalBloc {
  final _apiCaller = ApiCaller();

  //User Login
  final BehaviorSubject<LoginUserDataModel> _verifyUser =
      BehaviorSubject<LoginUserDataModel>();

  doUserLogin({
    String? phone,
    String? pass,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {"phone": phone, "password": pass};
    try {
      Map<String, dynamic> response = await _apiCaller.userLogincall(bodyData);
      log("doUserLogin Body Data : $bodyData---> RESPONSE: $response ");
      var res = LoginUserDataModel.fromJson(response);
      if (res.errorcode == 0 && res.msg.toLowerCase() == "success") {
        await StorageUtil.putString(
            localStorageData.ID, res.user.id.toString());
        StorageUtil.putString(localStorageData.NAME, res.user.name);
        StorageUtil.putString(
            localStorageData.ROLE_ID, res.user.roleId.toString());
        StorageUtil.putString(localStorageData.EMAIL, res.user.email);
        StorageUtil.putString(localStorageData.MALL_ID, res.user.mallIds);
        StorageUtil.putString(localStorageData.LOCATION, res.user.location);
        StorageUtil.putString(localStorageData.PHONE, res.user.phone);
        StorageUtil.putString(localStorageData.TOKEN, res.token);

        _verifyUser.add(res);

        EasyLoading.dismiss();
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HomePage(),
        //   ),
        // );
        return res;
      } else {
        globalUtils.showNegativeSnackBar(msg: res.msg);
        return res;
      }
      // if(res.)
    } catch (e) {
      throw "Something went wrong in doUserLogin: $e";
    }
  }

  //feedBack Question Data
  BehaviorSubject<FeedbackModel> get getFeedbackQueData => _liveFeedbackQueData;
  final BehaviorSubject<FeedbackModel> _liveFeedbackQueData =
      BehaviorSubject<FeedbackModel>();

  Future<FeedbackModel> doFetchFeedBackQueData() async {
    EasyLoading.show(dismissOnTap: false);
    try {
      Map<String, dynamic> res = await _apiCaller.getDataOfFeedBack();
      log('doFetchFeedBackQueData Response : $res');
      var data = FeedbackModel.fromJson(res);
      _liveFeedbackQueData.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      log("doFetchFeedBackQueData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }
}

GlobalBloc globalBloc = GlobalBloc();
