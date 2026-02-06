import 'dart:convert';
import 'http_request_manager.dart';

class VehicleService {
  final String apiUrl;
  final String idToken;

  VehicleService({required this.apiUrl, required this.idToken});

  Future<Map<String, dynamic>?> fetchVehicleDetails(String vehicleId) async {
    if (vehicleId.isEmpty || vehicleId == "error") {
      print("[VehicleService] Invalid vehicle ID: $vehicleId");
      return null;
    }

    try {
      final String cleanId = vehicleId.replaceAll('"', '').trim();

      final requestBody = {
        "idToken": idToken,
        "data": {
          "modelName": "VehicleData",
          "searchCriteria": {"id": cleanId},
        },
      };

      final response = await HttpRequestManager().post(
        uri: Uri.parse('$apiUrl/search'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
        priority: RequestPriority.normal,
        description: 'VehicleService.fetchVehicleDetails: $cleanId',
      );

      if (response.statusCode != 200) {
        print("[VehicleService] API error: ${response.statusCode}");
        return null;
      }

      final result = jsonDecode(response.body) as Map<String, dynamic>;

      if (result['results'] == null || (result['results'] as List).isEmpty) {
        print("[VehicleService] Vehicle not found: $cleanId");
        return null;
      }

      return (result['results'] as List).first as Map<String, dynamic>;
    } catch (e) {
      print("[VehicleService] Error: $e");
      return null;
    }
  }
}
