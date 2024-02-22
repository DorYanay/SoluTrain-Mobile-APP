import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:mobile/app_model.dart';
import 'package:mobile/config.dart' show Config;

// This file handle the communication with the API

class Response {
  final dynamic data;
  final int statusCode;
  final String errorBody;
  final String errorMessage;

  get hasError => statusCode != 200;

  Response(this.data, this.statusCode, this.errorBody, this.errorMessage);
}

class API {
  static Future<Response> guestPost(String endpoint,
      {Map<String, dynamic>? params, String? filePath}) async {
    if (kDebugMode) {
      print("API POST send Request: $endpoint");
    }

    var request = http.MultipartRequest(
        ''
        'POST',
        Uri(
            scheme: Config.apiIsHttps ? 'https' : 'http',
            host: Config.apiHost,
            port: Config.apiPort,
            path: endpoint,
            queryParameters: params));

    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    if (kDebugMode) {
      print("API POST get Response: $endpoint - ${response.statusCode}");
    }

    if (response.statusCode != 200) {
      String errorMessage = '';

      try {
        dynamic errorObject = jsonDecode(response.body);

        dynamic detail = errorObject['detail'];

        if (detail is String) {
          errorMessage = detail;
        }
      } on FormatException {
        errorMessage = '';
      }

      if (kDebugMode) {
        print("API POST ERROR Message: $endpoint - $errorMessage");
        print("API POST ERROR Body: $endpoint - ${response.body}");
      }

      return Response(null, response.statusCode, response.body, errorMessage);
    }

    dynamic data = jsonDecode(response.body);

    return Response(data, 200, '', '');
  }

  static Future<Response> guestGet(String endpoint,
      {Map<String, dynamic>? params}) async {
    if (kDebugMode) {
      print("API GET send Request: $endpoint");
    }

    final response = await http.get(Uri(
        scheme: Config.apiIsHttps ? 'https' : 'http',
        host: Config.apiHost,
        port: Config.apiPort,
        path: endpoint,
        queryParameters: params));

    if (kDebugMode) {
      print("API GET get Response: $endpoint - ${response.statusCode}");
    }

    if (response.statusCode != 200) {
      String errorMessage = '';

      try {
        dynamic errorObject = jsonDecode(response.body);

        dynamic detail = errorObject['detail'];

        if (detail is String) {
          errorMessage = detail;
        }
      } on FormatException {
        errorMessage = '';
      }

      if (kDebugMode) {
        print("API POST ERROR Message: $endpoint - $errorMessage");
        print("API POST ERROR Body: $endpoint - ${response.body}");
      }

      return Response(null, response.statusCode, response.body, errorMessage);
    }

    return Response(response.body, 200, '', '');
  }

  static Future<Response> post(BuildContext context, String endpoint,
      {Map<String, dynamic>? params, String? filePath}) async {
    params ??= <String, dynamic>{};

    params['auth_token'] =
        Provider.of<AppModel>(context, listen: false).authToken;

    return API.guestPost(endpoint, params: params, filePath: filePath);
  }

  static Future<Response> get(BuildContext context, String endpoint,
      {Map<String, dynamic>? params}) async {
    params ??= <String, dynamic>{};

    params['auth_token'] =
        Provider.of<AppModel>(context, listen: false).authToken;

    return API.guestGet(endpoint, params: params);
  }

  static String getURL(BuildContext context, String endpoint,
      {Map<String, dynamic>? params}) {
    params ??= <String, dynamic>{};

    params['auth_token'] =
        Provider.of<AppModel>(context, listen: false).authToken;

    Uri uri = Uri(
        scheme: Config.apiIsHttps ? 'https' : 'http',
        host: Config.apiHost,
        port: Config.apiPort,
        path: endpoint,
        queryParameters: params);

    return uri.toString();
  }

  API._();
}
