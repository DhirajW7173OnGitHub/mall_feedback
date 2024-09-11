import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mall_app/Api_caller/api_wrapper.dart';
import 'package:mall_app/Environment/base_data.dart';
import 'package:mall_app/SSL_Pinning/ssl_pinning.dart';

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

  //Mark Attendance
  //------------------------Sign Up---------------------//
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

  //End Mark Attendance
  //------------------------Sign Up---------------------//
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

  //Menu Data Api
  //------------------------Sign Up---------------------//
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

  //Feedback Question Data
  //------------------------Sign Up---------------------//
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

  //------------------------Save Feed Back---------------------//
  Future<Map<String, dynamic>?> uploadFeedbackData(List<Map> feedback) async {
    _client = await getSSLPinningClient();

    final String uri = '$baseUrl/savefeedback';

    var url = Uri.parse(uri);
    var headers = {
      'Content-Type': 'application/json',
    };

    // Convert the feedback list to ensure answers are always strings
    var formattedFeedback = feedback.map((item) {
      var answers = item['answers'];
      if (answers is List) {
        answers = answers.join(', ');
      }
      return {
        'question_id': item['question_id'],
        'answers': answers,
      };
    }).toList();

    var bodyData = jsonEncode({
      'feedback': formattedFeedback,
    });

    log('Url: $uri Request BodyData: $bodyData');

    try {
      final response = await _client.post(
        url,
        headers: headers,
        body: bodyData,
      );
      print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = jsonDecode(response.body);
        print('All responses received successfully');
        return responseJson;
      } else {
        print('API call failed with status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('uploadFeedbackData Error: $e');
      return null;
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
}
