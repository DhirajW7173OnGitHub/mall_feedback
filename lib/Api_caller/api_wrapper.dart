import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mall_app/Environment/base_data.dart';
import 'package:mall_app/SSL_Pinning/ssl_pinning.dart';
import 'package:mall_app/Utils/app_exception.dart';
import 'package:mall_app/Utils/global_utils.dart';

class ApiWrapper {
  static late http.Client _client;

  // Make a GET request to the API
  static Future<Map<String, dynamic>> get(String endpoint) async {
    //Initialize Custom Client
    _client = await getSSLPinningClient();

    final url = Uri.parse('$baseUrl/$endpoint');
    log('url: $url');
    final response = await _client.get(url);

    return _processResponse(response);
  }

  // Make a POST request to the API
  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic body) async {
    _client = await getSSLPinningClient();
    final url = Uri.parse('$baseUrl/$endpoint');
    log('url: $url' + ' body: $body ');

    final response = await _client.post(url, body: body);

    return _processResponse(response);
  }

  static dynamic _processResponse(http.Response response) {
    log('Response Status Code : ${response.statusCode} ');
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      // break;
      case 201:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        debugPrint("${response.request}");
        globalUtils.showNegativeSnackBar(msg: 'Api not responding');
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
        globalUtils.showNegativeSnackBar(msg: response.body);

        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());

      case 403:
        globalUtils.showNegativeSnackBar(msg: response.body);

        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());

      case 422:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 404:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());

      default:
        try {
          globalUtils.showNegativeSnackBar(
            msg: jsonDecode(response.body)['data']['message'],
          );
        } catch (e) {
          print(e);
        }
        throw Exception(jsonDecode(response.body)['data']['message']);
    }
  }
}
