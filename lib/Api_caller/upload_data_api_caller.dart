import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mall_app/Environment/base_data.dart';
import 'package:mall_app/SSL_Pinning/ssl_pinning.dart';

class UploadFileDataApiCaller {
  static late http.Client _client;

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
}
