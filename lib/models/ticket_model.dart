import 'dart:convert';

class Ticket {
  final String id;
  final String ticketNumber;
  final String userClient;
  final String vehicle;
  final String status;
  final String location;
  final String notes;
  final String companyId;
  final String email;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? vehicleData;
  final String? clientPhotoUrl;

  Ticket({
    required this.id,
    required this.ticketNumber,
    required this.userClient,
    required this.vehicle,
    required this.status,
    required this.location,
    required this.notes,
    required this.companyId,
    required this.email,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.vehicleData,
    this.clientPhotoUrl,
  });

  factory Ticket.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);

    return Ticket(
      id: json['id'] ?? '',
      ticketNumber: json['ticket_number'] ?? '',
      userClient: json['user_client'] ?? '',
      vehicle: json['vehicle'] ?? '',
      status: json['status'] ?? '',
      location: json['location'] ?? '',
      notes: json['notes'] ?? '',
      companyId: json['companyId'] ?? '',
      email: json['email'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
      vehicleData: json['vehicleData'],
      clientPhotoUrl:
          json['clientPhoto'] ?? json['photo'] ?? json['client_photo'],
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();

    if (timestamp is Map) {
      // Firestore timestamp
      final seconds = timestamp['_seconds'] ?? timestamp['seconds'] ?? 0;
      final nanoseconds =
          timestamp['_nanoseconds'] ?? timestamp['nanoseconds'] ?? 0;
      final milliseconds = (seconds * 1000) + (nanoseconds ~/ 1000000);
      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    }

    if (timestamp is String) {
      return DateTime.tryParse(timestamp) ?? DateTime.now();
    }

    return DateTime.now();
  }

  String get timeDifference {
    final now = DateTime.now().toUtc();
    final diff = now.difference(createdAt.toUtc());

    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    return '${days.toString().padLeft(2, '0')}d '
        '${hours.toString().padLeft(2, '0')}h '
        '${minutes.toString().padLeft(2, '0')}m '
        '${seconds.toString().padLeft(2, '0')}s';
  }

  String get formattedVehicle {
    if (vehicleData == null) return "Vehicle info unavailable";

    final year = vehicleData!['vehicle_year']?.toString() ?? '';
    final make = vehicleData!['vehicle_make'] ?? '';
    final model = vehicleData!['vehicle_model'] ?? '';
    final color = vehicleData!['color'] ?? '';
    final plate = vehicleData!['license_plate'] ?? '';

    List<String> parts = [];
    if (year.isNotEmpty) parts.add(year);
    if (make.isNotEmpty) parts.add(make);
    if (model.isNotEmpty) parts.add(model);

    String desc = parts.join(" ");

    if (color.isNotEmpty) {
      desc += " - $color";
    }

    if (plate.isNotEmpty) {
      desc += " ($plate)";
    }

    return desc.isEmpty ? "Vehicle info unavailable" : desc;
  }

  bool get hasClientPhoto {
    return clientPhotoUrl != null &&
        clientPhotoUrl!.isNotEmpty &&
        clientPhotoUrl != "error" &&
        clientPhotoUrl!.length > 10;
  }

  Ticket copyWith({
    Map<String, dynamic>? vehicleData,
  }) {
    return Ticket(
      id: id,
      ticketNumber: ticketNumber,
      userClient: userClient,
      vehicle: vehicle,
      status: status,
      location: location,
      notes: notes,
      companyId: companyId,
      email: email,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      vehicleData: vehicleData ?? this.vehicleData,
      clientPhotoUrl: clientPhotoUrl,
    );
  }
}
