import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/vehicle_service.dart';

class TicketDetailPage extends StatefulWidget {
  final String ticketJson;
  final String apiUrl;
  final String idToken;

  const TicketDetailPage({
    Key? key,
    required this.ticketJson,
    required this.apiUrl,
    required this.idToken,
  }) : super(key: key);

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  late Ticket ticket;
  bool isLoadingVehicle = true;

  @override
  void initState() {
    super.initState();
    ticket = Ticket.fromJson(widget.ticketJson);
    _loadVehicleData();
  }

  Future<void> _loadVehicleData() async {
    if (ticket.vehicle.isEmpty) {
      setState(() => isLoadingVehicle = false);
      return;
    }

    final service = VehicleService(
      apiUrl: widget.apiUrl,
      idToken: widget.idToken,
    );

    final data = await service.fetchVehicleDetails(ticket.vehicle);

    if (mounted && data != null) {
      setState(() {
        ticket = ticket.copyWith(vehicleData: data);
        isLoadingVehicle = false;
      });
    } else {
      setState(() => isLoadingVehicle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            const Divider(height: 32),

            // Time Section
            _buildTimeSection(),
            const Divider(height: 32),

            // Vehicle Section
            _buildVehicleSection(),
            const Divider(height: 32),

            // Client Section
            _buildClientSection(),
            const Divider(height: 32),

            // Notes Section
            if (ticket.notes.isNotEmpty) _buildNotesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ticket #${ticket.ticketNumber}",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            ticket.status.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "TIME",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time, color: Colors.blue[700]),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Time Elapsed",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                  Text(
                    ticket.timeDifference,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Created: ${_formatDateTime(ticket.createdAt)}",
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildVehicleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "VEHICLE",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        if (isLoadingVehicle)
          const CircularProgressIndicator()
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_car, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ticket.formattedVehicle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (ticket.vehicleData != null) ...[
                  const SizedBox(height: 12),
                  _buildVehicleDetailRow(
                    "Make",
                    ticket.vehicleData!['vehicle_make'] ?? 'Unknown',
                  ),
                  _buildVehicleDetailRow(
                    "Model",
                    ticket.vehicleData!['vehicle_model'] ?? 'Unknown',
                  ),
                  _buildVehicleDetailRow(
                    "Year",
                    ticket.vehicleData!['vehicle_year']?.toString() ??
                        'Unknown',
                  ),
                  _buildVehicleDetailRow(
                    "Color",
                    ticket.vehicleData!['color'] ?? 'Unknown',
                  ),
                  _buildVehicleDetailRow(
                    "License Plate",
                    ticket.vehicleData!['license_plate'] ?? 'Unknown',
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildVehicleDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildClientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CLIENT",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: ticket.hasClientPhoto
              ? CircleAvatar(
                  backgroundImage: NetworkImage(ticket.clientPhotoUrl!),
                )
              : CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person),
                ),
          title: Text(ticket.email),
          subtitle: Text("ID: ${ticket.userClient}"),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "NOTES",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.yellow[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.yellow[200]!),
          ),
          child: Text(ticket.notes),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (ticket.status.toLowerCase()) {
      case 'arrival':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.month}/${dt.day}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
