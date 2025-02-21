import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/header.dart';
import 'package:grad_project/screensWorkers/single_request_screen.dart';

import '../components/request_card.dart';
import '../state_management/providers/offer_provider.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(title: 'Pending Offers', backBtn: false),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('allOffers')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where('status',isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Offers found.'));
                }
                final offerDocs = snapshot.data!.docs;

                final requestIds = offerDocs
                    .map((offerDoc) => offerDoc['requestId'] as String)
                    .toList();
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Requests')
                      .where(
                        FieldPath.documentId,
                        whereIn: requestIds,
                      ) // Use requestIds to filter requests
                      .snapshots(),
                  builder: (context, requestSnapshot) {
                    if (requestSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!requestSnapshot.hasData ||
                        requestSnapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No requests found.'));
                    }

                    final requests = requestSnapshot.data!.docs;
                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final doc = requests[index];
                        final data = doc.data()
                            as Map<String, dynamic>; // Cast data to Map

                        return RequestCard(
                          title: data['title'] ?? 'Untitled Request',
                          images: List<String>.from(data['images'] ?? []),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SingleRequestScreen(requestId: doc.id,isWorker: true,),
                              ),
                            );
                          },
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
