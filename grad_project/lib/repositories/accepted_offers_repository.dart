import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/models/Request_offer_worker_model.dart';
import 'package:grad_project/models/offer_model.dart';
import 'package:grad_project/models/user_model.dart';

import '../models/offer_worker_model.dart';
import '../models/request_model.dart';

class AcceptedOfferRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  AcceptedOfferRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  Future<List<RequestOfferWorker>> fetchOngoingCustomerOrders() async {
    try {
      // Step 1: Fetch all requests made by the current user
      final requestSnapshot = await _firebaseFirestore
          .collection('Requests')
          .where('userId', isEqualTo: currentUserId)
          .get();

      if (requestSnapshot.docs.isEmpty) {
        print('userr:$currentUserId');
        print('No requests found for user(repository).');
        return [];
      }

      // Step 2: Convert request documents into RequestModel list
      Map<String, RequestModel> requestMap = {
        for (var doc in requestSnapshot.docs)
          doc.id: RequestModel.fromMap(doc.data() as Map<String, dynamic>)
      };

      List<String> requestIds = requestMap.keys.toList();
      print('Fetched ${requestIds.length} requests for user.');

      // Step 3: Fetch accepted offers for these requests
      List<OfferWorkerModel> offersWithWorkers =
      await fetchAcceptedOffersWithWorkers(requestIds);

      List<RequestOfferWorker> requestOfferWorkers = [];

      // Step 4: Check for ongoing orders before adding to the list
      for (OfferWorkerModel offerWithWorker in offersWithWorkers) {
        String requestId = offerWithWorker.offer.requestId;

        if (!requestMap.containsKey(requestId)) {
          print('❌ Warning: Offer found without matching request: $requestId');
          continue;
        }

        // Step 5: Check if the order status is NOT completed
        bool isOngoing = await _isOrderOngoing(requestId);
        if (!isOngoing) {
          print('⏹ Skipping completed order for requestId: $requestId');
          continue;
        }

        // Step 6: Add to list if order is ongoing
        requestOfferWorkers.add(RequestOfferWorker(
          request: requestMap[requestId]!,
          offer: offerWithWorker.offer,
          worker: offerWithWorker.worker,
        ));
      }

      return requestOfferWorkers;
    } catch (e) {
      print('Error fetching ongoing/accepted requests: $e');
      return [];
    }
  }

  // Future<List<RequestOfferWorker>> fetchOngoingCustomerOrders() async {
  //   try {
  //     // Fetch all requests made by the current user
  //     final requestSnapshot = await _firebaseFirestore
  //         .collection('Requests')
  //         .where('userId', isEqualTo: currentUserId)
  //         .get();
  //
  //     if (requestSnapshot.docs.isEmpty) {
  //       print('No requests found for user.');
  //       return [];
  //     }
  //
  //     // Convert request documents into RequestModel list
  //     List<RequestModel> requests = requestSnapshot.docs.map((doc) {
  //       return RequestModel.fromMap(doc.data() as Map<String, dynamic>);
  //     }).toList();
  //
  //     // Map requestId to request for quick lookup
  //     Map<String, RequestModel> requestMap = {
  //       for (var doc in requestSnapshot.docs)
  //         doc.id: RequestModel.fromMap(doc.data() as Map<String, dynamic>)
  //     };
  //
  //     // Extract request IDs for Firestore query
  //     List<String> requestIds = requestSnapshot.docs.map((doc) => doc.id).toList();
  //
  //     print('Fetched ${requests.length} requests for user.');
  //
  //     // Fetch all accepted offers for these requests
  //     List<OfferWorkerModel> offersWithWorkers = await fetchAcceptedOffersWithWorkers(requestIds);
  //
  //     List<RequestOfferWorker> requestOfferWorkers = [];
  //
  //     // Match offers with the correct requests
  //     for (OfferWorkerModel offerWithWorker in offersWithWorkers) {
  //       if (requestMap.containsKey(offerWithWorker.offer.requestId)) {
  //         requestOfferWorkers.add(RequestOfferWorker(
  //           request: requestMap[offerWithWorker.offer.requestId]!,
  //           offer: offerWithWorker.offer,
  //           worker: offerWithWorker.worker,
  //         ));
  //       } else {
  //         print('❌ Warning: Offer found without matching request: ${offerWithWorker.offer.requestId}');
  //       }
  //     }
  //
  //     return requestOfferWorkers;
  //   } catch (e) {
  //     print('Error fetching ongoing/accepted requests: $e');
  //     return [];
  //   }
  // }
  Future<bool> _isOrderOngoing(String requestId) async {
    try {
      final orderSnapshot = await _firebaseFirestore
          .collection('orders')
          .where('requestId', isEqualTo: requestId)
          .get();

      // If no order found → Consider as ongoing
      if (orderSnapshot.docs.isEmpty) {
        return true;
      }

      // Check if any order is still ongoing (not marked as completed)
      for (var doc in orderSnapshot.docs) {
        String status = doc['status'] ?? 'unknown';
        if (status != "completed") {
          return true; // Order is still ongoing
        }
      }

      return false; // No ongoing orders found
    } catch (e) {
      print('Error checking order status: $e');
      return false;
    }
  }

  Future<List<OfferWorkerModel>> fetchAcceptedOffersWithWorkers(List<String> requestIds) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('allOffers')
          .where('requestId', whereIn: requestIds)
          .where('status', isEqualTo: 'accepted')
          .get();

      // Extract accepted offers
      List<Offer> acceptedOffers = querySnapshot.docs.map((doc) {
        return Offer.fromMap(doc.data(), doc.id);
      }).toList();


      List<Future<UserModel?>> workerFutures = [];
      for (Offer offer in acceptedOffers) {
        workerFutures.add(FirebaseFirestore.instance
            .collection('workers')
            .doc(offer.userId)
            .get()
            .then((workerSnapshot) {
          if (workerSnapshot.exists) {
            final workerData = workerSnapshot.data();
            return UserModel.fromMap(workerData!, workerSnapshot.id);
          } else {
            return null;
          }
        }));
      }


      List<UserModel?> workers = await Future.wait(workerFutures);


      List<OfferWorkerModel> offersWithWorkers = [];
      for (int i = 0; i < acceptedOffers.length; i++) {

        if (workers[i] != null) {
          offersWithWorkers.add(OfferWorkerModel(
            offer: acceptedOffers[i],
            worker: workers[i]!,
          ));
        }
      }

      return offersWithWorkers;
    } catch (e) {
      print('Error fetching accepted offers with workers: $e');
      return [];
    }
  }
  Future<void> moveAcceptedOfferToOrders(String offerId) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Step 1: Fetch the accepted offer from allOffers
      final offerSnapshot = await _firestore.collection('allOffers').doc(offerId).get();

      if (!offerSnapshot.exists) {
        print("❌ Error: Offer not found.");
        return;
      }

      final offerData = offerSnapshot.data() as Map<String, dynamic>;
      final String requestId = offerData['requestId']; // Get the request ID
      final String workerId = offerData['userId']; // Get the worker's ID

      // Step 2: Fetch the customer ID from the Requests collection
      final requestSnapshot = await _firestore.collection('Requests').doc(requestId).get();

      if (!requestSnapshot.exists) {
        print("❌ Error: Request not found.");
        return;
      }

      final requestData = requestSnapshot.data() as Map<String, dynamic>;
      final String customerId = requestData['userId']; // Get the customer’s ID

      // Step 3: Add the accepted offer to the Orders collection
      await _firestore.collection('orders').add({
        'offerId': offerId,
        'workerId': workerId,
        'customerId': customerId,
        'requestId': requestId,
        'price': offerData['price'],
        'description': offerData['description'],
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'ongoing',
        'rated' : false,// Initial status for the order
      });

      print("✅ Offer successfully moved to Orders collection.");
    } catch (e) {
      print("🔥 Error moving accepted offer to Orders: $e");
    }
  }
  Future<void> deleteRequestAndRelatedData(String requestId) async {
    try {
      final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

      WriteBatch batch = _firebaseFirestore.batch();

      // Delete all related offers
      QuerySnapshot offerSnapshots = await _firebaseFirestore
          .collection('allOffers')
          .where('requestId', isEqualTo: requestId)
          .get();

      for (var doc in offerSnapshots.docs) {
        batch.delete(doc.reference);
      }

      // Delete the related order (if exists)
      QuerySnapshot orderSnapshots = await _firebaseFirestore
          .collection('orders')
          .where('requestId', isEqualTo: requestId)
          .get();

      for (var doc in orderSnapshots.docs) {
        batch.delete(doc.reference);
      }

      // Delete the request itself
      DocumentReference requestRef =
      _firebaseFirestore.collection('Requests').doc(requestId);
      batch.delete(requestRef);

      // Commit all deletions
      await batch.commit();

      print("✅ Successfully deleted request, related offers, and orders.");
    } catch (e) {
      print("🔥 Error deleting request and related data: $e");
    }
  }

}
