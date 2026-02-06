// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import '../../services/http_request_manager.dart';

// Define a custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() {
    return 'ApiException: $message ${statusCode != null ? '(Status Code: $statusCode)' : ''}';
  }
}

Future<String> sendjsontourl(
  String jsonString,
  String token,
  String baseUrl,
) async {
  // Reduced verbosity - only key info
  print('[sendjsontourl] Starting request to: $baseUrl');
  
  // Explicit parameter validation
  if (jsonString.isEmpty) {
    throw ApiException('JSON string cannot be null or empty');
  }
  if (baseUrl.isEmpty) {
    throw ApiException('Base URL cannot be null or empty');
  }

  // URI parsing
  Uri uri;
  try {
    uri = Uri.parse(baseUrl);
  } catch (e) {
    throw ApiException('URI parsing failed: ${e.toString()}', statusCode: -1);
  }

  // Prepare request body
  String requestBody;
  try {
    dynamic jsonData = json.decode(jsonString);
    Map<String, dynamic> postData = {"idToken": token, "data": jsonData};
    requestBody = jsonEncode(postData);
  } catch (e) {
    throw ApiException('Error parsing JSON string: ${e.toString()}', statusCode: -2);
  }

  // Make request using HTTP Manager (queued)
  try {
    final response = await HttpRequestManager().post(
      uri: uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: requestBody,
      priority: RequestPriority.normal,
      description: 'sendjsontourl: $baseUrl',
      timeout: const Duration(seconds: 30),
    );

    // Response handling
    if (response.statusCode == 200) {
      try {
        dynamic responseData = json.decode(response.body);
        print('[sendjsontourl] Success: ${response.statusCode}');
        return jsonEncode(responseData);
      } catch (e) {
        return jsonEncode({
          'status': 'success',
          'message': 'Response parsing failed',
          'originalBody': response.body,
          'error': e.toString(),
        });
      }
    } else {
      String errorMessage;
      switch (response.statusCode) {
        case 400:
          errorMessage = 'Bad request: Invalid data format';
          break;
        case 401:
          errorMessage = 'Unauthorized: Invalid token';
          break;
        case 403:
          errorMessage = 'Forbidden: Insufficient permissions';
          break;
        case 404:
          errorMessage = 'API endpoint not found';
          break;
        case 500:
          errorMessage = 'Server error occurred';
          break;
        default:
          errorMessage = 'Request failed with status: ${response.statusCode}';
      }
      print('[sendjsontourl] Error: $errorMessage');
      return response.statusCode.toString();
    }
  } on TimeoutException catch (e) {
    print('[sendjsontourl] Timeout: ${e.message}');
    throw ApiException('Request timed out: ${e.message}', statusCode: -4);
  } catch (e) {
    print('[sendjsontourl] Error: ${e.toString()}');
    throw ApiException('HTTP request failed: ${e.toString()}', statusCode: -5);
  }
}
