// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/http_request_manager.dart';

class statusResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String? error;
  final int? statusCode;

  statusResponse({
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

// Simplified logging
void _log(String message) {
  print('[setStatus] $message');
}

// Input validation class
class InputValidator {
  static void validateInputs({
    required String token,
    required String status,
    required String firebaseUrl,
    required String ticketId,
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
    if (ticketId.isEmpty) {
      throw ArgumentError('ticketId cannot be empty');
    }

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

Future<String> setStatus(
  String firebaseUrl,
  String token,
  String status,
  String ticketId,
) async {
  // Clean the ticketId by removing surrounding quotes if present
  final cleanTicketId = ticketId.replaceAll('"', '').trim();
  
  _log('Starting for ticket: $cleanTicketId');
  try {
    // Validate inputs
    InputValidator.validateInputs(
      token: token,
      status: status,
      firebaseUrl: firebaseUrl,
      ticketId: cleanTicketId,
    );

    final response = await HttpRequestManager().post(
      uri: Uri.parse(firebaseUrl),
      headers: {'Content-Type': 'application/json'},
      body: {
        'idToken': token,
        "data": {
          "id": cleanTicketId,
          "status": status,
        },
      },
      priority: RequestPriority.critical, // Status updates are critical
      description: 'setStatus: $cleanTicketId',
      timeout: const Duration(seconds: 30),
    );

    final result = _processResponse(response);
    _log('Completed: ${result.success ? "success" : "failed"}');
    return jsonEncode(result.toJson());
  } catch (e) {
    _log('Error: $e');
    return jsonEncode(
      statusResponse(
        success: false,
        message: 'Operation failed',
        error: e.toString(),
      ).toJson(),
    );
  }
}

// Helper function to process HTTP response
statusResponse _processResponse(http.Response response) {
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return statusResponse(
      success: true,
      message: 'status updated successfully',
      data: jsonDecode(response.body),
      statusCode: response.statusCode,
    );
  }

  return statusResponse(
    success: false,
    message: 'Failed to update status: ${response.reasonPhrase}',
    error: response.body,
    statusCode: response.statusCode,
  );
}
