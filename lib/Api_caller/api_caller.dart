import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mall_app/Api_caller/api_wrapper.dart';
import 'package:mall_app/Environment/base_data.dart';
import 'package:mall_app/SSL_Pinning/ssl_pinning.dart';

class ApiCaller {
  static late http.Client _client;

  //User Login
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

  //Feedback Question Data
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

  //Save Feed Back
  Future<Map<String, dynamic>?> uploadFeedbackData(List<Map> feedback) async {
    _client = await getSSLPinningClient();
    var url = Uri.parse('$baseUrl/savefeedback');

    log("Url : $url");

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

    var body = jsonEncode({'feedback': formattedFeedback});

    log('Request Body: $body');

    try {
      final response = await _client.post(url, headers: headers, body: body);
      log('Response Status Code: ${response.statusCode}');
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
}
