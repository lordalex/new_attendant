// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/http_request_manager.dart';

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

// Simplified logging
void _log(String message) {
  print('[creaTicket] $message');
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
  String Site,
  String vehicleInfo,
  String PIN,
  String mail,
) async {
  _log('Starting');
  try {
    // Validate inputs
    InputValidator.validateInputs(
      token: token,
      firebaseUrl: firebaseUrl,
      PIN: PIN,
    );

    final response = await HttpRequestManager().post(
      uri: Uri.parse(firebaseUrl),
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
      priority: RequestPriority.critical, // Ticket creation is critical
      description: 'creaTicket: $Site',
      timeout: const Duration(seconds: 30),
    );

    final result = _processResponse(response);
    _log('Completed: ${result.success ? "success" : "failed"}');
    return jsonEncode(result.toJson());
  } catch (e) {
    _log('Error: $e');
    return jsonEncode(
      ticketdataResponse(
        success: false,
        message: 'Operation failed',
        error: e.toString(),
      ).toJson(),
    );
  }
}

// Helper function to process HTTP response
ticketdataResponse _processResponse(http.Response response) {
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
