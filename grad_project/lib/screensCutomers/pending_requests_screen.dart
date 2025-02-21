import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/header.dart';

import '../components/request_card.dart';
import '../screensWorkers/single_request_screen.dart';


class PendingRequestsScreen extends StatelessWidget {
  const PendingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(title: 'Your Request', backBtn: false),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Requests')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where('status',isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No requests found.'));
                }

                final offerDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: offerDocs.length,
                  itemBuilder: (context, index) {
                    final doc = offerDocs[index];
                    final data = doc.data() as Map<String, dynamic>; // Cast data to Map

                    return RequestCard(
                      title: data['title'] ?? 'Untitled Request',
                      images: List<String>.from(data['images'] ?? []),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleRequestScreen(requestId: doc.id,isWorker: false,),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )

        ],
      ),
    );
  }
}
