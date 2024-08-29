import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mall_app/Api_caller/api_caller.dart';
import 'package:mall_app/feedback/Model/feedback_model.dart';
import 'package:rxdart/rxdart.dart';

class GlobalBloc {
  final _apiCaller = ApiCaller();

  //User Login
  doUserLogin({
    String? phone,
    String? pass,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {"phone": phone, "password": pass};
    try {
      var res = await _apiCaller.userLogincall(bodyData);
      log("doUserLogin Body Data : $bodyData---> RESPONSE: $res ");
      // if(res.)
    } catch (e) {
      throw "Something went wrong in checkOtp: $e";
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
