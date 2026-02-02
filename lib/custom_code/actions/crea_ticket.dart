// Automatic FlutterFlow imports
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';

class TicketdataResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String? error;
  final int? statusCode;

  TicketdataResponse({
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
    required String firebaseUrl,
    required String pin,
  }) {
    if (token.isEmpty) {
      throw ArgumentError('Token cannot be empty');
    }
    if (firebaseUrl.isEmpty) {
      throw ArgumentError('firebase URL cannot be empty');
    }
    if (pin.isEmpty) {
      throw ArgumentError('PIN cannot be empty');
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

Future<String> creaTicket(
  String firebaseUrl,
  String token,
  String site,
  String vehicleInfo,
  String pin,
  String mail,
) async {
  logMessage(LogLevel.info, 'Starting sendticketdata operation');
  try {
    // Validate inputs
    logMessage(LogLevel.info, 'Validating input parameters');
    InputValidator.validateInputs(
      token: token,
      firebaseUrl: firebaseUrl,
      pin: pin,
    );
    final uri = Uri.parse(firebaseUrl);
    // Prepare request with retry mechanism
    print(firebaseUrl);
    print(site);
    final response = await _sendRequestWithRetry(
      uri: uri,
      headers: {'Content-Type': 'application/json'},
      body: {
        'idToken': token,
        "data": {
          "site": site.replaceAll('"', ""),
          "PIN": pin,
          "mail": mail,
          "vehicleInfo": vehicleInfo,
        },
      },
    );
    // Process response
    final ticketResponse = _processResponse(response);
    print(response);
    logMessage(LogLevel.info, 'Operation completed successfully');
    return jsonEncode(ticketResponse.toJson());
  } catch (e) {
    logMessage(LogLevel.error, 'Error in sendticketdata: $e');
    return jsonEncode(
      TicketdataResponse(
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
TicketdataResponse _processResponse(http.Response response) {
  logMessage(LogLevel.info, 'Processing response: ${response.statusCode}');
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return TicketdataResponse(
      success: true,
      message: 'ticketdata updated successfully',
      data: jsonDecode(response.body),
      statusCode: response.statusCode,
    );
  }

  return TicketdataResponse(
    success: false,
    message: 'Failed to update ticketdata: ${response.reasonPhrase}',
    error: response.body,
    statusCode: response.statusCode,
  );
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
