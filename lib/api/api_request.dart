import 'dart:convert';
import 'package:http/http.dart' as http;
import 'headers.dart';

Future<http.Response?> apiRequest(String endUrl, String method, {dynamic body, bool isFormData = false}) async {
  final headers = getCommonHeaders(isFormData: isFormData);
  final uri = Uri.parse(endUrl);
  final jsonBody = body != null ? jsonEncode(body) : null;

  print(uri);

  try {
    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'POST':
        return await http.post(uri, headers: headers, body: jsonBody);
      case 'PUT':
        return await http.put(uri, headers: headers, body: jsonBody);
      case 'DELETE':
        return await http.delete(uri, headers: headers, body: jsonBody);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  } catch (error) {
    print('Error from API call: $error');
    throw Exception('API request failed');
  }
}