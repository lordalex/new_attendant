// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';

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
  print('Starting sendJsonData function...');
  print(jsonString);
  // Explicit parameter validation
  if (jsonString.isEmpty) {
    throw ApiException('JSON string cannot be null or empty');
  }
  if (baseUrl.isEmpty) {
    throw ApiException('Base URL cannot be null or empty');
  }

  // URI parsing block
  Uri uri;
  try {
    uri = Uri.parse(baseUrl);
    print('URI parsed successfully: $uri');
  } catch (e) {
    print('Error parsing URI: ${e.toString()}');
    throw ApiException('URI parsing failed: ${e.toString()}', statusCode: -1);
  }

  // Request data preparation block
  String requestBody;
  try {
    // Attempt to parse JSON string to a JSON object
    dynamic jsonData = json.decode(jsonString);

    // Construct the outer JSON structure
    Map<String, dynamic> postData = {"idToken": token, "data": jsonData};

    print(postData);

    requestBody = jsonEncode(postData);
    print('Request data prepared: $requestBody');
  } catch (e) {
    print('Error parsing JSON string: ${e.toString()}');
    throw ApiException(
      'Error parsing JSON string: ${e.toString()}',
      statusCode: -2,
    );
  }

  // Headers preparation block
  Map<String, String> headers;
  try {
    headers = {'Content-Type': 'application/json; charset=UTF-8'};
    print('Headers prepared: $headers');
  } catch (e) {
    print('Error preparing headers: ${e.toString()}');
    throw ApiException(
      'Headers preparation failed: ${e.toString()}',
      statusCode: -3,
    );
  }

  // HTTP request block
  http.Response response;
  try {
    print('Sending HTTP request...');
    response = await http
        .post(uri, headers: headers, body: requestBody)
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            print('Request timed out');
            throw ApiException(
              'Request timed out after 30 seconds',
              statusCode: -4,
            );
          },
        );
    print('Response received with status code: ${response.statusCode}');
  } catch (e) {
    print('Error in HTTP request: ${e.toString()}');
    throw ApiException('HTTP request failed: ${e.toString()}', statusCode: -5);
  }

  // Response handling block
  try {
    print('Processing response...');
    if (response.statusCode == 200) {
      try {
        // Try to parse response body
        dynamic responseData = json.decode(response.body);
        print('Response parsed successfully: $responseData');
        return jsonEncode(responseData); // Return the stringified JSON data
      } catch (e) {
        print('Could not parse response body: ${e.toString()}');
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
      print('API Error: $errorMessage (Status Code: ${response.statusCode})');
      print(response.body);
      return response.statusCode.toString();
    }
  } catch (e) {
    print('Error processing response: ${e.toString()}');
    throw ApiException(
      'Response processing failed: ${e.toString()}',
      statusCode: -6,
      data: jsonEncode({
        'message': 'Response processing failed',
        'error': e.toString(),
      }),
    );
  }
}
