import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mall_app/Environment/base_data.dart';
import 'package:mall_app/Utils/app_exception.dart';
import 'package:mall_app/Utils/global_utils.dart';

class ApiWrapper {
  // Make a GET request to the API
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    log('url: $url');
    final response = await http.get(url);

    return _processResponse(response);
  }

  // This methos only for create JWT
  // static Future<Map<String, dynamic>> getPost(String endpoint) async {
  //   final url = Uri.parse('$baseUrl/$endpoint');
  //   log('url: $url');
  //   final response = await _client.post(
  //     url,
  //     headers: <String, String>{"X-API-KEY": "@rddmsInt0uch2023"},
  //   ); //await http.get(

  //   if (response.statusCode == 200) {
  //     var responseData = jsonDecode(response.body);
  //     return responseData;
  //   } else if (response.statusCode == 401) {
  //     Map<String, dynamic> data = await authBloc.doFetchJwToken();
  //     return data;
  //   } else {
  //     return {};
  //   }
  // }

  // Make a POST request to the API
  //Additional header is added
  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    log('url: $url' + ' body:$body ');

    final response = await http.post(url,
        // headers: <String, String>{"Authorization": CommonString.TOKEN},
        body: body);

    return _processResponse(response);
  }

  //This method only used for send_otp, check_otp, Menu_Api
  static Future<Map<String, dynamic>> jwtPost(
      String endpoint, dynamic body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    log('url: $url' + ' body:$body ');

    final response = await http.post(url,
        // headers: <String, String>{"Authorization": CommonString().JWT},
        body: body);

    return _processResponse(response);
  }

  //////USE IT ONLY FOR CATLOG API
  static Future<Map<String, dynamic>> postwithHeaders(
    String url,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    log('url: $url' + 'body:$body');
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    return _processResponse(response);
  }

  static dynamic _processResponse(http.Response response) {
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
        //  globalUtils.showNegativeSnackBar(message: 'Api not responding');
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
