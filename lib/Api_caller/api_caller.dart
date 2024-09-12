import 'package:http/http.dart' as http;
import 'package:mall_app/Api_caller/api_wrapper.dart';

class ApiCaller {
  static late http.Client _client;

  //------------------------Sign Up---------------------//
  Future<Map> userSignUpWithData(Map body) async {
    var endPoint = "signup";

    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("userSignUpWithData body Data : $body -- Response : $res");
      return res;
    } catch (e) {
      print('userSignUpWithData Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //------------------------User Login---------------------//
  Future<Map<String, dynamic>> userLogincall(Map body) async {
    var endPoint = "userlogin";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("userLogincall body Data : $body -- Response : $res");
      return res;
    } catch (e) {
      print('userLogincall Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //------------------------Mark Attendance---------------------//
  Future<Map> markUserAttendance(Map body) async {
    var endPoint = "mark-attendance";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      print('markUserAttendance Body Data : $body --Response : $res');
      return res;
    } catch (e) {
      print('markUserAttendance Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //------------------------End Mark Attendance---------------------//
  Future<Map> endMarkUserAttendance(Map body) async {
    var endPoint = "end-attendance";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      print('endMarkUserAttendance Body Data : $body --Response : $res');
      return res;
    } catch (e) {
      print('endMarkUserAttendance Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //------------------------Menu Data Api---------------------//
  Future<Map<String, dynamic>> getMobileMenuData(Map body) async {
    var endPoint = "get-mobile-menu";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("getMobileMenuData Body Data : $body -- Response : $res");
      return res;
    } catch (e) {
      print('getMobileMenuData Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //------------------------Feedback Question Data---------------------//
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

  //----------Attendance Data Fetch get-attendance-data--------------//
  Future<Map<String, dynamic>> getUserAttendanceDetails(Map body) async {
    var endPoint = "get-attendance-data";

    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("getUserAttendanceDetails body Data : $body --Response : $res");
      return res;
    } catch (e) {
      print('uploadFeedbackData Error: $e');
      throw "Something Went Wrong $e";
    }
  }

  //----------------Order-History API----------------//
  Future<Map> getOrderHistoryData(Map body) async {
    var endPoint = "orders-history";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("getOrderHistoryData body Data : $body --Response : $res");
      return res;
    } catch (e) {
      print('getOrderHistoryData Error: $e');
      throw "getOrderHistoryData Something Went Wrong $e";
    }
  }
}
