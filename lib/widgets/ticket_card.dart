import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/vehicle_service.dart';

class TicketCard extends StatefulWidget {
  final String ticketJson;
  final String apiUrl;
  final String idToken;
  final VoidCallback? onTap;

  const TicketCard({
    Key? key,
    required this.ticketJson,
    required this.apiUrl,
    required this.idToken,
    this.onTap,
  }) : super(key: key);

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  late Ticket ticket;
  bool isLoadingVehicle = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    ticket = Ticket.fromJson(widget.ticketJson);
    _loadVehicleData();
  }

  Future<void> _loadVehicleData() async {
    if (ticket.vehicle.isEmpty) {
      setState(() {
        isLoadingVehicle = false;
      });
      return;
    }

    try {
      final vehicleService = VehicleService(
        apiUrl: widget.apiUrl,
        idToken: widget.idToken,
      );

      final vehicleData =
          await vehicleService.fetchVehicleDetails(ticket.vehicle);

      if (mounted) {
        setState(() {
          if (vehicleData != null) {
            ticket = ticket.copyWith(vehicleData: vehicleData);
          }
          isLoadingVehicle = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Failed to load vehicle";
          isLoadingVehicle = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Photo or Placeholder
              _buildPhoto(),
              const SizedBox(width: 16),

              // Main Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ticket Number and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ticket #${ticket.ticketNumber}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildStatusChip(),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Time Difference
                    _buildTimeDifference(),
                    const SizedBox(height: 12),

                    // Vehicle Info
                    _buildVehicleInfo(),
                    const SizedBox(height: 8),

                    // Email
                    Text(
                      ticket.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    // Notes (if any)
                    if (ticket.notes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Notes: ${ticket.notes}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    if (!ticket.hasClientPhoto) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.person,
          size: 30,
          color: Colors.grey,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.network(
        ticket.clientPhotoUrl!,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              size: 30,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    switch (ticket.status.toLowerCase()) {
      case 'arrival':
        chipColor = Colors.orange;
        break;
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.blue;
    }

    return Chip(
      label: Text(
        ticket.status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildTimeDifference() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        ticket.timeDifference,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.blue[700],
        ),
      ),
    );
  }

  Widget _buildVehicleInfo() {
    if (isLoadingVehicle) {
      return Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Loading vehicle...",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    }

    if (errorMessage != null) {
      return Text(
        errorMessage!,
        style: TextStyle(
          fontSize: 14,
          color: Colors.red[600],
        ),
      );
    }

    return Row(
      children: [
        Icon(
          Icons.directions_car,
          size: 18,
          color: Colors.grey[700],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            ticket.formattedVehicle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
