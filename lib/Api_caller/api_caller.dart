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
  Future<Map<String, dynamic>> getOrderHistoryData(Map body) async {
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

  //------------------Order Item History-----------------//
  Future<Map<String, dynamic>> getItemHistoryData(Map body) async {
    var endPoint = "item-history";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("getItemHistoryData body Data : $body --Response : $res");
      return res;
    } catch (e) {
      print('getItemHistoryData Error: $e');
      throw "getItemHistoryData Something Went Wrong $e";
    }
  }

  //----------------Purchase-History API----------------//
  Future<Map<String, dynamic>> getPurchaseHistoryData(Map body) async {
    var endPoint = "savePurchaseHistory";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("getPurchaseHistoryData body Data : $body --Response : $res");
      return res;
    } catch (e) {
      print('getPurchaseHistoryData Error: $e');
      throw "getPurchaseHistoryData Something Went Wrong $e";
    }
  }

  //----------------Mall List API----------------//
  Future<Map<String, dynamic>> getMallListData() async {
    var endPoint = "mall-list";
    try {
      final res = await ApiWrapper.get(endPoint);
      print("getMallListData body Data Response : $res");
      return res;
    } catch (e) {
      print('getMallListData Error: $e');
      throw "getMallListData Something Went Wrong $e";
    }
  }

  //----------------Purchase Count API----------------//
  Future<Map> getPurchaseCount(Map body) async {
    var endPoint = "purchase-count";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      print("getPurchaseCount body Data : $body --Response : $res");
      return res;
    } catch (e) {
      print('getPurchaseCount Error: $e');
      throw "getPurchaseCount Something Went Wrong $e";
    }
  }
}
