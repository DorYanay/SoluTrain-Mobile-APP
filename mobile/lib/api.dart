import 'dart:convert';
import 'package:http/http.dart' as http;
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
  static const String serverScheme = 'http';
  static const String serverHost = '10.9.7.195';
  static const int serverPort = 8000;

  static Future<Response> post(String endpoint, {Map<String, dynamic>? params, Schema? body}) async {
    String bodyJson = '{}';

    if (body != null) {
      bodyJson = jsonEncode(body.toJson());
    }

    final response = await http.post(
      Uri(
          scheme: serverScheme,
          host: serverHost,
          port: serverPort,
          path: endpoint,
          queryParameters: params
      ),
      body: bodyJson,
      headers: {'Content-Type': 'application/json'},
    );

    dynamic data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return Response(null, response.statusCode, response.body);
    }

    return Response(data, 200, '');
  }

  API._();
}
