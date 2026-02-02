// Automatic FlutterFlow imports
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';

class StatusResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String? error;
  final int? statusCode;

  StatusResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    this.statusCode,
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    if (data != null) 'data': data,
    if (error != null) 'error': error,
    if (statusCode != null) 'statusCode': statusCode,
  };
}

// Logging levels with color coding
enum LogLevel {
  info,
  warning,
  error;

  String get ansiColor {
    switch (this) {
      case LogLevel.info:
        return '\x1B[32m'; // Green
      case LogLevel.warning:
        return '\x1B[33m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m'; // Red
    }
  }
}

// Enhanced logging function
void logMessage(LogLevel level, String message) {
  final timestamp = DateTime.now().toIso8601String();
  final prefix = level.toString().split('.').last;
  const resetColor = '\x1B[0m';
  print('${level.ansiColor}[$timestamp][$prefix] $message$resetColor');
}

// Input validation class
class InputValidator {
  static void validateInputs({
    required String token,
    required String status,
    required String firebaseUrl,
  }) {
    if (token.isEmpty) {
      throw ArgumentError('Token cannot be empty');
    }
    if (status.isEmpty) {
      throw ArgumentError('status cannot be empty');
    }
    if (firebaseUrl.isEmpty) {
      throw ArgumentError('firebase URL cannot be empty');
    }

    // Validate URL format
    try {
      final uri = Uri.parse(firebaseUrl);
      if (!uri.isAbsolute) {
        throw const FormatException('Invalid firebase URL format');
      }
    } catch (e) {
      throw FormatException('Invalid URL format: $e');
    }
  }
}

Future<String> setStatus(
  String firebaseUrl,
  String token,
  String status,
) async {
  logMessage(LogLevel.info, 'Starting sendstatus operation');
  try {
    // Validate inputs
    logMessage(LogLevel.info, 'Validating input parameters');
    InputValidator.validateInputs(
      token: token,
      status: status,
      firebaseUrl: firebaseUrl,
    );
    final uri = Uri.parse(firebaseUrl);
    // Prepare request with retry mechanism
    final response = await _sendRequestWithRetry(
      uri: uri,
      headers: {'Content-Type': 'application/json'},
      body: {
        'idToken': token,
        "data": {"id": "string"},
      },
    );
    // Process response
    final statusResult = _processResponse(response);
    logMessage(LogLevel.info, 'Operation completed successfully');
    return jsonEncode(statusResult.toJson());
  } catch (e) {
    logMessage(LogLevel.error, 'Error in sendstatus: $e');
    return jsonEncode(
      StatusResponse(
        success: false,
        message: 'Operation failed',
        error: e.toString(),
      ).toJson(),
    );
  }
}

// Helper function to send request with retry mechanism
Future<http.Response> _sendRequestWithRetry({
  required Uri uri,
  required Map<String, String> headers,
  required Map<String, dynamic> body,
  int maxRetries = 3,
  Duration retryDelay = const Duration(seconds: 1),
}) async {
  int attempts = 0;
  while (attempts < maxRetries) {
    try {
      logMessage(
        LogLevel.info,
        'Sending HTTP request (attempt ${attempts + 1}/$maxRetries)',
      );

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      // Only retry on 5xx server errors
      if (response.statusCode < 500) {
        return response;
      }

      attempts++;
      if (attempts < maxRetries) {
        logMessage(
          LogLevel.warning,
          'Request failed with ${response.statusCode}, retrying...',
        );
        await Future.delayed(retryDelay * attempts);
      }
    } on http.ClientException catch (e) {
      logMessage(LogLevel.error, 'Network error: $e');
      attempts++;
      if (attempts >= maxRetries) rethrow;
      await Future.delayed(retryDelay * attempts);
    }
  }
  throw Exception('Max retry attempts reached');
}

// Helper function to process HTTP response
StatusResponse _processResponse(http.Response response) {
  logMessage(LogLevel.info, 'Processing response: ${response.statusCode}');

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return StatusResponse(
      success: true,
      message: 'status updated successfully',
      data: jsonDecode(response.body),
      statusCode: response.statusCode,
    );
  }

  return StatusResponse(
    success: false,
    message: 'Failed to update status: ${response.reasonPhrase}',
    error: response.body,
    statusCode: response.statusCode,
  );
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
