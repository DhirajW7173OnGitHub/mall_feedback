import 'package:mall_app/Api_caller/api_wrapper.dart';

class ApiCaller {
  Future<Map<String, dynamic>> getDataOfFeedBack() async {
    var endPoint = "feedback-questions";

    try {
      final res = await ApiWrapper.get(endPoint);
      print('getDataOfFeedBack Response : $res');
      return res;
    } catch (e) {
      print('getDataOfFeedBack Error : $e');
      throw "Something went Wrong : $e";
    }
  }
}
