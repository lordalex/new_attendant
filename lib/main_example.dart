import 'package:flutter/material.dart';
import 'pages/tickets_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KNEX Valet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example ticket JSON
    final exampleTickets = [
      '{"id":"yNSKHjNUAzsdHMIQVy9O","user_client":"VSWcxRLsyjg8ip3KiMah","vehicle":"fpjSMNhudv4rUEWarsGp","status":"Arrival","location":"wvPCzGA3J7UJwpUhmI1H","notes":"","companyId":"HbqR2hlv2C0hvLCV442h","email":"gassahara@gmail.com","ticket_number":"916ebf27-bc30-4e72-b6d3-4cd9e3968513","createdBy":"la@lordalexand.co","createdAt":{"_seconds":1770119622,"_nanoseconds":497000000},"updatedAt":{"_seconds":1770119622,"_nanoseconds":497000000}}',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('KNEX Valet Dashboard'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TicketsListPage(
                  apiUrl: "https://api.knex-app.xyz/api",
                  idToken: "YOUR_FIREBASE_ID_TOKEN_HERE",
                  ticketsJsonList: exampleTickets,
                ),
              ),
            );
          },
          child: const Text('View Tickets'),
        ),
      ),
    );
  }
}

// USAGE IN YOUR REAL APP:
/*
1. Get your Firebase ID token from your auth system
2. Pass your tickets list from your API response
3. Navigate to TicketsListPage:

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TicketsListPage(
      apiUrl: "https://api.knex-app.xyz/api",
      idToken: await FirebaseAuth.instance.currentUser!.getIdToken(),
      ticketsJsonList: yourTicketsList, // List<String> of ticket JSONs
    ),
  ),
);
*/
