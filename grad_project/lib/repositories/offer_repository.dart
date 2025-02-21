import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grad_project/models/offer_model.dart';
import 'package:grad_project/models/offer_worker_model.dart';
import 'package:grad_project/models/request_model.dart';
import 'package:grad_project/models/user_model.dart';

class OfferRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String currentUserId;
  bool alreadyOffered = false;

  OfferRepository(
      {FirebaseFirestore? firebaseFirestore, required this.currentUserId})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;



  Future<void> createOffer({
    required String requestId,
    required double price,
    required String description,
    required String currentUserId,
  }) async
  {
    final offer = Offer(
      id: '',
      requestId: requestId,
      userId: currentUserId,
      price: price,
      description: description,
      createdAt: DateTime.now(),
      status: 'pending',
    );

    try {
      if (await checkRequestForOffer(requestId) != null) {
        print('Cannot make more than one offer for this request.');

        alreadyOffered = true;
      } else {
        // Proceed to add the new offer to Firestore
        await _firebaseFirestore.collection('allOffers').add(offer.toMap());
        print('Offer created successfully.');
      }
    } catch (e) {
      print('Error creating offer: $e');
      rethrow; // Optionally handle the error
    }
  }
  Future<Map<String, dynamic>?> checkRequestForOffer(String requestId) async {
    final offerSnapshot = await _firebaseFirestore
        .collection('allOffers')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    final offerDocs = offerSnapshot.docs;

    final requestIds =
        offerDocs.map((offerDoc) => offerDoc['requestId'] as String).toList();

    // Check if the offer already exists for the provided requestId
    if (requestIds.contains(requestId)) {
      // Find the offer document where the requestId matches
      final offerDoc = offerDocs.firstWhere(
        (offer) => offer['requestId'] == requestId,
      );

      // Return the price and description if offer exists
      return {
        'price': offerDoc['price'],
        'description': offerDoc['description'],
      };
    } else {
      // Return null if no offer exists
      return null;
    }
  }
  Future<void> updateOffer({
    required String requestId,
    required double price,
    required String description,
  })
  async {
    final offerSnapshot = await _firebaseFirestore
        .collection('allOffers')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('requestId', isEqualTo: requestId)
        .get();

    if (offerSnapshot.docs.isNotEmpty) {
      final offerDoc = offerSnapshot.docs.first;

      final updatedOffer = {
        'price': price,
        'description': description,
        'createdAt': DateTime.now(),
      };

      try {
        await _firebaseFirestore
            .collection('allOffers')
            .doc(offerDoc.id)
            .update(updatedOffer);

        print('Offer updated successfully!');
      } catch (e) {
        print('Error updating offer: $e');
        rethrow;
      }
    } else {
      print('Offer not found for requestId: $requestId');
    }
  }




  Future<void> acceptOffer(String offerId, String requestId) async {
    try {
      // Accept the selected offer
      await FirebaseFirestore.instance.collection('allOffers').doc(offerId).update({
        'status': 'accepted',
      });
      await FirebaseFirestore.instance.collection('Requests').doc(requestId).update(
          {'status': true});
      print('Offer accepted successfully.');

      // Now reject all other offers with the same requestId
      final snapshot = await FirebaseFirestore.instance
          .collection('allOffers')
          .where('requestId', isEqualTo: requestId)
          .where('status', isEqualTo: 'pending') // optional to only reject pending offers
          .get();

      // Reject all offers except the accepted one
      for (var doc in snapshot.docs) {
        if (doc.id != offerId) {
          await doc.reference.update({
            'status': 'rejected',
          });
          print('Offer ${doc.id} rejected.');
        }
      }
    } catch (e) {
      print('Error accepting and rejecting offers: $e');
    }
  }
  Future<void> rejectOffer(String offerId) async {
    try {
      await FirebaseFirestore.instance.collection('allOffers').doc(offerId).update({
        'status': 'rejected',
      });
      print('Offer rejected successfully.');
    } catch (e) {
      print('Error rejecting offer: $e');
    }
  }
  Future<void> setPending() async {
    try {
      // Fetch all offers from the collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('allOffers')
          .get(); // This fetches all documents in the collection

      // Loop through all the documents and update them one by one
      for (var doc in snapshot.docs) {
        await doc.reference.update({
          'status': 'pending', // Set the status to 'pending'
        });
      }

      print('All offers updated to pending successfully.');
    } catch (e) {
      print('Error updating all offers: $e');
    }
  }







  Stream<List<OfferWorkerModel>> getOffersWithWorkers(String requestId) {
    print('🔄 Repository: Fetching offers for requestId: $requestId');

    return _firebaseFirestore
        .collection('allOffers')
        .where('requestId', isEqualTo: requestId)
    .where('status', whereIn: ['pending','accepted'])
        .snapshots()
        .asyncMap((snapshot) async {
      print('📦 Repository: Found ${snapshot.docs.length} offer documents');

      try {
        final workerIds = snapshot.docs
            .map((doc) => doc['userId'] as String)
            .where((id) => id.isNotEmpty)
            .toSet()
            .toList();

        print('👷 Repository: Worker IDs to fetch: $workerIds');

        final workers = await _getWorkersInBatches(workerIds);
        print('👥 Repository: Found ${workers.length} workers');

        final offers = snapshot.docs.map((doc) {
          final offer = Offer.fromMap(doc.data(), doc.id);
          final worker = workers[offer.userId] ;
          print('✅ Processed offer ${offer.id} with worker ${worker?.uid}');
          print('Offer createdAt: ${offer.createdAt}');
          print('Worker name: ${worker?.name}');
          return OfferWorkerModel(offer: offer, worker: worker);
        }).toList();

        return offers;
      } catch (e) {
        print('🔥 Repository error: $e');
        return [];
      }
    });
  }
  Future<Map<String, UserModel>> _getWorkersInBatches(List<String> workerIds) async {
    final Map<String, UserModel> workers = {};

    for (var i = 0; i < workerIds.length; i += 10) {
      final batch = workerIds.sublist(i, i + 10 > workerIds.length ? workerIds.length : i + 10);

      final snapshot = await _firebaseFirestore
          .collection('workers')
          .where(FieldPath.documentId, whereIn: batch)
          .get();

      for (final doc in snapshot.docs) {
        workers[doc.id] = UserModel.fromMap(doc.data(), doc.id);
      }
    }

    return workers;
  }

}
