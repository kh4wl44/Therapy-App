import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TherapistClients extends StatefulWidget {
  @override
  State<TherapistClients> createState() => _TherapistClientsState();
}

class _TherapistClientsState extends State<TherapistClients> {
  List<Client> clients = []; // List to hold client information

  // Method to simulate accepting a client session
  void acceptClient(String name, String imageUrl) {
    setState(() {
      clients.add(Client(name: name, imageUrl: imageUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("العملاء", style: GoogleFonts.almarai(color: Colors.white)),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: clients.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              Icons.people_rounded,
              size: 80,
              color: Colors.purple,
            ),
            SizedBox(height: 20),
            Text(
              "لا يوجد عملاء بعد.",
              style: GoogleFonts.almarai(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          return ClientCard(client: clients[index]);
        },
      ),
    );
  }
}

class Client {
  final String name;
  final String imageUrl;

  Client({required this.name, required this.imageUrl});
}

class ClientCard extends StatelessWidget {
  final Client client;

  const ClientCard({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(client.imageUrl), // Load client image
        ),
        title: Text(client.name, style: GoogleFonts.almarai()),
      ),
    );
  }
}