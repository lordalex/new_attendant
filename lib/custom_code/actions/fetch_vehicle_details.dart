// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import '../../services/http_request_manager.dart';

Future<String> fetchVehicleDetails(
  String vehicleId,
  String apiUrl,
  String idToken,
) async {
  if (vehicleId == null || vehicleId.isEmpty || vehicleId == "error") {
    print("[fetchVehicleDetails] Invalid vehicle ID: $vehicleId");
    return jsonEncode({
      'error': 'INVALID_VEHICLE_ID',
      'message': 'Vehicle ID is empty or invalid',
    });
  }

  try {
    // Clean the vehicleId (remove quotes if present)
    final String cleanId = vehicleId.replaceAll('"', '').trim();

    // Prepare request body
    final requestBody = {
      "idToken": idToken,
      "data": {
        "modelName": "Vehicle",
        "searchCriteria": {"id": cleanId},
      },
    };

    // Make API request using HTTP Manager
    final response = await HttpRequestManager().post(
      uri: Uri.parse('$apiUrl/search'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
      priority: RequestPriority.normal,
      description: 'fetchVehicleDetails: $cleanId',
    );

    if (response.statusCode != 200) {
      print("[fetchVehicleDetails] API error: ${response.statusCode}");
      return jsonEncode({
        'error': 'API_ERROR',
        'message': 'Failed to fetch vehicle details',
        'status_code': response.statusCode,
      });
    }

    final result = jsonDecode(response.body) as Map<String, dynamic>;

    if (result['results'] == null || (result['results'] as List).isEmpty) {
      print("[fetchVehicleDetails] Vehicle not found: $cleanId");
      return jsonEncode({
        'error': 'VEHICLE_NOT_FOUND',
        'message': 'Vehicle not found in database',
        'vehicle_id': cleanId,
      });
    }

    final vehicleData =
        (result['results'] as List).first as Map<String, dynamic>;

    print("[fetchVehicleDetails] Success: ${vehicleData['model'] ?? vehicleData['vehicle_model'] ?? 'Unknown'}");

    // Return relevant vehicle fields per OpenAPI spec
    return jsonEncode({
      'success': true,
      'id': cleanId,
      'vehicle_make': vehicleData['vehicle_make'] ?? 'Unknown Make',
      'vehicle_model': vehicleData['vehicle_model'] ?? 'Unknown Model',
      'vehicle_year': vehicleData['vehicle_year']?.toString() ?? '',
      'color': vehicleData['color'] ?? 'Unknown Color',
      'license_plate': vehicleData['license_plate'] ?? '',
      'vin': vehicleData['vin'] ?? '',
    });
  } catch (e) {
    print("[fetchVehicleDetails] Error: $e");
    return jsonEncode({
      'error': 'FETCH_ERROR',
      'message': 'Failed to fetch vehicle details',
      'details': e.toString(),
    });
  }
}
