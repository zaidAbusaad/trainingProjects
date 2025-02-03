import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/models/service_card_model.dart';
import 'package:grad_project/screensWorkers/single_request_screen.dart';

import '../components/cutom_shapes/circular_container.dart';
import '../components/cutom_shapes/curved_edges.dart';
import '../components/request_card.dart';

class RequestsScreenWorker extends StatelessWidget {
  const RequestsScreenWorker({super.key, required this.field});

  final ServiceCardModel field;

  @override
  Widget build(BuildContext context) {
    var fieldName = field.fieldName;

    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: CurvedEdges(),
            child: Container(
              height: 150,
              decoration: const BoxDecoration(color: Colors.blue),
              child: Stack(
                children: [
                  const Positioned(
                    top: -150,
                    right: -250,
                    child: CircularContainer(),
                  ),
                  const Positioned(
                    top: 100,
                    right: -300,
                    child: CircularContainer(),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 60,
                    child: Text(
                      '$fieldName Requests.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Requests')
                  .where('field', isEqualTo: fieldName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No requests found.'));
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final doc = requests[index];
                    final data = doc.data() as Map<String, dynamic>; // Cast data to Map

                    return RequestCard(
                      title: data['title'] ?? 'Untitled Request',
                      images: List<String>.from(data['images'] ?? []),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleRequestScreen(requestId: doc.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
