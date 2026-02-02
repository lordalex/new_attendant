// Automatic FlutterFlow imports
import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
import 'package:knexattendant/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';

class ticketdataResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String? error;
  final int? statusCode;

  ticketdataResponse({
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
  INFO,
  WARNING,
  ERROR;

  String get ansiColor {
    switch (this) {
      case LogLevel.INFO:
        return '\x1B[32m'; // Green
      case LogLevel.WARNING:
        return '\x1B[33m'; // Yellow
      case LogLevel.ERROR:
        return '\x1B[31m'; // Red
    }
  }
}

// Enhanced logging function
void logMessage(LogLevel level, String message) {
  final timestamp = DateTime.now().toIso8601String();
  final prefix = level.toString().split('.').last;
  final resetColor = '\x1B[0m';
  print('${level.ansiColor}[$timestamp][$prefix] $message$resetColor');
}

// Input validation class
class InputValidator {
  static void validateInputs({
    required String token,
    required String firebaseUrl,
    required String PIN,
  }) {
    if (token.isEmpty) {
      throw ArgumentError('Token cannot be empty');
    }
    if (firebaseUrl.isEmpty) {
      throw ArgumentError('firebase URL cannot be empty');
    }
    if (PIN.isEmpty) {
      throw ArgumentError('PIN cannot be empty');
    }
    const ticketdata = {};
    // Validate URL format
    try {
      final uri = Uri.parse(firebaseUrl);
      if (!uri.isAbsolute) {
        throw FormatException('Invalid firebase URL format');
      }
    } catch (e) {
      throw FormatException('Invalid URL format: $e');
    }
  }
}

Future<String> creaTicket(
  String firebaseUrl,
  String token,
  String Site,
  String vehicleInfo,
  String PIN,
  String mail,
) async {
  logMessage(LogLevel.INFO, 'Starting sendticketdata operation');
  try {
    // Validate inputs
    const ticketdata = {};
    logMessage(LogLevel.INFO, 'Validating input parameters');
    InputValidator.validateInputs(
      token: token,
      firebaseUrl: firebaseUrl,
      PIN: PIN,
    );
    final uri = Uri.parse(firebaseUrl);
    // Prepare request with retry mechanism
    print(firebaseUrl);
    print(Site);
    final response = await _sendRequestWithRetry(
      uri: uri,
      headers: {'Content-Type': 'application/json'},
      body: {
        'idToken': token,
        "data": {
          "site": Site.replaceAll('"', ""),
          "PIN": PIN,
          "mail": mail,
          "vehicleInfo": vehicleInfo,
        },
      },
    );
    // Process response
    final ticketdataResponse = _processResponse(response);
    print(response);
    logMessage(LogLevel.INFO, 'Operation completed successfully');
    return jsonEncode(ticketdataResponse.toJson());
  } catch (e) {
    logMessage(LogLevel.ERROR, 'Error in sendticketdata: $e');
    return jsonEncode(
      ticketdataResponse(
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
        LogLevel.INFO,
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
          LogLevel.WARNING,
          'Request failed with ${response.statusCode}, retrying...',
        );
        await Future.delayed(retryDelay * attempts);
      }
    } on http.ClientException catch (e) {
      logMessage(LogLevel.ERROR, 'Network error: $e');
      attempts++;
      if (attempts >= maxRetries) rethrow;
      await Future.delayed(retryDelay * attempts);
    }
  }
  throw Exception('Max retry attempts reached');
}

// Helper function to process HTTP response
ticketdataResponse _processResponse(http.Response response) {
  logMessage(LogLevel.INFO, 'Processing response: ${response.statusCode}');
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return ticketdataResponse(
      success: true,
      message: 'ticketdata updated successfully',
      data: jsonDecode(response.body),
      statusCode: response.statusCode,
    );
  }

  return ticketdataResponse(
    success: false,
    message: 'Failed to update ticketdata: ${response.reasonPhrase}',
    error: response.body,
    statusCode: response.statusCode,
  );
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
