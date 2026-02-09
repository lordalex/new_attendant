// EXAMPLE: How to use the new system in your existing widget
// Replace your current slidable_tile_ticket_list_arrival_widget.dart with this pattern

import 'package:flutter/material.dart';
import '../../models/ticket_model.dart';
import '../../services/vehicle_service.dart';

class SlidableTileTicketListArrivalWidget extends StatefulWidget {
  final String ticketJson;
  final String apiUrl;
  final String idToken;

  const SlidableTileTicketListArrivalWidget({
    super.key,
    required this.ticketJson,
    required this.apiUrl,
    required this.idToken,
  });

  @override
  State<SlidableTileTicketListArrivalWidget> createState() =>
      _SlidableTileTicketListArrivalWidgetState();
}

class _SlidableTileTicketListArrivalWidgetState
    extends State<SlidableTileTicketListArrivalWidget> {
  late Ticket ticket;
  bool isLoadingVehicle = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Parse the ticket JSON once
    ticket = Ticket.fromJson(widget.ticketJson);
    // Fetch vehicle data
    _loadVehicleData();
  }

  Future<void> _loadVehicleData() async {
    print("[SlidableTile] Loading vehicle data for ticket: ${ticket.id}");
    print("[SlidableTile] Vehicle ID: ${ticket.vehicle}");

    if (ticket.vehicle.isEmpty) {
      print("[SlidableTile] No vehicle ID found");
      setState(() => isLoadingVehicle = false);
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
            print(
                "[SlidableTile] Vehicle data loaded: ${vehicleData['vehicle_model']}");
            ticket = ticket.copyWith(vehicleData: vehicleData);
          } else {
            print("[SlidableTile] Vehicle data is null");
            errorMessage = "Vehicle not found";
          }
          isLoadingVehicle = false;
        });
      }
    } catch (e) {
      print("[SlidableTile] Error loading vehicle: $e");
      if (mounted) {
        setState(() {
          errorMessage = "Error loading vehicle";
          isLoadingVehicle = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildPhoto(),
        title: Text("Ticket #${ticket.ticketNumber}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ TIME DIFFERENCE - Working!
            Text(
              ticket.timeDifference, // "02d 10h 10m 47s"
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // ✅ VEHICLE INFO - Now working!
            if (isLoadingVehicle)
              const Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text("Loading vehicle...", style: TextStyle(fontSize: 12)),
                ],
              )
            else if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              )
            else
              Text(
                ticket
                    .formattedVehicle, // "2023 Toyota Camry - Silver (CA-ABC123)"
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),

            // ✅ CLIENT EMAIL
            Text(
              ticket.email,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(ticket.status),
          backgroundColor: _getStatusColor(),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    if (!ticket.hasClientPhoto) {
      return CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, color: Colors.grey[600]),
      );
    }

    return CircleAvatar(
      backgroundImage: NetworkImage(ticket.clientPhotoUrl!),
      onBackgroundImageError: (exception, stackTrace) {
        print("[SlidableTile] Error loading image: $exception");
      },
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
}

// USAGE IN YOUR PARENT WIDGET:
/*
SlidableTileTicketListArrivalWidget(
  ticketJson: ticketItem,  // Your ticket JSON string
  apiUrl: "https://api.knex-app.xyz/api",
  idToken: await FirebaseAuth.instance.currentUser!.getIdToken(),
)
*/
