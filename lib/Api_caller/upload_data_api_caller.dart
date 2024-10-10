import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:mall_app/Environment/base_data.dart';
import 'package:mall_app/SSL_Pinning/ssl_pinning.dart';
import 'package:mall_app/Utils/common_log.dart';
import 'package:mall_app/Utils/global_utils.dart';

class UploadFileDataApiCaller {
  static late http.Client _client;

  //------------------------Save Feed Back---------------------//
  Future<Map<String, dynamic>?> uploadFeedbackData(
      String userId, List<Map> feedback) async {
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
      'userid': userId,
      'feedback': formattedFeedback,
    });

    Logger.dataLog('Url: $uri Request BodyData: $bodyData');

    try {
      final response = await _client.post(
        url,
        headers: headers,
        body: bodyData,
      );
      Logger.dataPrint('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = jsonDecode(response.body);
        Logger.dataPrint('All responses received successfully');
        return responseJson;
      } else {
        Logger.dataPrint(
            'API call failed with status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      Logger.dataPrint('uploadFeedbackData Error: $e');
      return null;
    }
  }

  //-----------------Final Order of Product Data------------------//
  Future<Map?> finalProductOrderUploadData({
    String? userId,
    String? mallId,
    required List<Map<String, dynamic>> productList,
  }) async {
    _client = await getSSLPinningClient();
    EasyLoading.show(dismissOnTap: false);
    final String uri = '$baseUrl/redeem-product';
    var url = Uri.parse(uri);
    var headers = {
      'Content-Type': 'application/json',
    };

    var bodyData = {
      "customer_id": userId,
      "mall_id": mallId,
      "products": productList,
    };
    //jsonEncode();

    Logger.dataLog('Url: $uri Request BodyData: $bodyData');

    try {
      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode(bodyData),
      );
      Logger.dataPrint('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        final responseJson = jsonDecode(response.body);
        Logger.dataPrint('All responses received successfully');
        return responseJson;
      } else {
        EasyLoading.dismiss();
        Logger.dataPrint(
            'API call failed with status code ${response.statusCode} -- ${response.body}');
        globalUtils.showToastMessage("Something Wrong :${response.body}");
        return null;
      }
    } catch (e) {
      Logger.dataPrint('uploadFeedbackData Error: $e');
      return null;
    }
  }
}
