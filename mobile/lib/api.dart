import 'dart:convert';
import 'package:http/http.dart' as http;

import 'config.dart' show Config;
import 'schemas.dart' show Schema;

// This file handle the communication with the API

class Response {
  final dynamic data;
  final int statusCode;
  final String errorMessage;

  get hasError => statusCode != 200;

  Response(this.data, this.statusCode, this.errorMessage);
}

class API {
  static Future<Response> post(String endpoint, {Map<String, dynamic>? params}) async {
    final response = await http.post(
      Uri(
          scheme: Config.apiIsHttps ? 'https' : 'http',
          host: Config.apiHost,
          port: Config.apiPort,
          path: endpoint,
          queryParameters: params
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      return Response(null, response.statusCode, response.body);
    }

    dynamic data = jsonDecode(response.body);

    return Response(data, 200, '');
  }

  API._();
}
