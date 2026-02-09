import 'package:flutter/material.dart';
import 'dart:convert';
import '../widgets/ticket_card.dart';

class TicketsListPage extends StatelessWidget {
  final String apiUrl;
  final String idToken;
  final List<String> ticketsJsonList;

  const TicketsListPage({
    super.key,
    required this.apiUrl,
    required this.idToken,
    required this.ticketsJsonList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: ticketsJsonList.length,
        itemBuilder: (context, index) {
          return TicketCard(
            ticketJson: ticketsJsonList[index],
            apiUrl: apiUrl,
            idToken: idToken,
            onTap: () {
              // Handle ticket tap
              print("Tapped ticket: $index");
            },
          );
        },
      ),
    );
  }
}

// Example usage in main.dart or wherever you navigate:
/*
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TicketsListPage(
      apiUrl: "https://api.knex-app.xyz/api",
      idToken: yourFirebaseToken,
      ticketsJsonList: [
        '{"id":"yNSKHjNUAzsdHMIQVy9O","ticket_number":"916ebf27-bc30-4e72-b6d3-4cd9e3968513","vehicle":"fpjSMNhudv4rUEWarsGp","status":"Arrival","email":"gassahara@gmail.com","createdAt":{"_seconds":1770119622,"_nanoseconds":497000000},"updatedAt":{"_seconds":1770119622,"_nanoseconds":497000000}}',
        // ... more tickets
      ],
    ),
  ),
);
*/
