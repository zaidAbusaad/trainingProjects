import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/customer_order.dart';
import '../models/offer_model.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';

class AcceptedOfferWorkerRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  AcceptedOfferWorkerRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<CustomerOrderModel>> fetchCustomerOrders() async {
    try {
      print("🔍 Fetching orders for workerId: $currentUserId");

      final ordersSnapshot = await _firebaseFirestore
          .collection('orders')
          .where('status',isEqualTo: "ongoing")
          .where('workerId', isEqualTo: currentUserId)

          .get();

      if (ordersSnapshot.docs.isEmpty) {
        print("⚠ No orders found for this worker.");
        return [];
      }

      List<CustomerOrderModel> customerOrders = [];

      for (var orderDoc in ordersSnapshot.docs) {
        final orderData = orderDoc.data();
        final requestId = orderData['requestId'];
        final offerId = orderData['offerId'];
        final customerId = orderData['customerId'];

        print(
            "📄 Found Order: requestId=$requestId, offerId=$offerId, customerId=$customerId");

        // Fetch Request
        final requestDoc = await _firebaseFirestore
            .collection('Requests')
            .doc(requestId)
            .get();
        if (!requestDoc.exists) {
          print("⚠ Request Not Found: $requestId");
          continue;
        }
        final request = RequestModel.fromMap(requestDoc.data()!);

        // Fetch Customer
        final customerDoc = await _firebaseFirestore
            .collection('Customers')
            .doc(customerId)
            .get();
        if (!customerDoc.exists) {
          print("⚠ Customer Not Found: $customerId");
          continue;
        }
        final customer = UserModel.fromMap(customerDoc.data()!, customerId);

        // Fetch Offer
        final offerDoc =
            await _firebaseFirestore.collection('allOffers').doc(offerId).get();
        if (!offerDoc.exists) {
          print("⚠ Offer Not Found: $offerId");
          continue;
        }
        final offer = Offer.fromMap(offerDoc.data()!, offerId);

        customerOrders.add(CustomerOrderModel(
          orderId: orderDoc.id,
          offer: offer,
          request: request,
          customer: customer,
        ));
      }

      print("✅ Total Orders Fetched: ${customerOrders.length}");
      return customerOrders;
    } catch (e) {
      print("🔥 Error fetching customer orders: $e");
      return [];
    }
  }

  Future<void> markOrderAsCompleted(String orderDocId) async { // Rename parameter
    try {
      await _firebaseFirestore.collection('orders').doc(orderDocId).update({
        "status": "completed",
        "completedAt": FieldValue.serverTimestamp(),
      });
      print("✅ Order marked as completed: $orderDocId");
    } catch (e) {
      print("🔥 Error marking order as completed: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> listenForOrderCompletion(String customerId) {
    print("🔍 Checking for completed orders for customer: $customerId");

    return _firebaseFirestore
        .collection('orders')
        .where('customerId', isEqualTo: customerId)
        .where('status', isEqualTo: "completed")
        .snapshots()
        .map((snapshot) {
      print("📩 Orders snapshot received: ${snapshot.docs.length}");

      return snapshot.docs.map((doc) {
        final data = doc.data();
        print("📄 Order Data: $data");

        return {
          "docId": doc.id,
          "workerId": data["workerId"] ?? "Unknown",
          "status": data["status"] ?? "MISSING_STATUS",
          "rated": data.containsKey("rated") ? data["rated"] : false, // ✅ Safe check
        };
      }).toList();
    });
  }

  Future<void> rateWorker(String workerId, String orderId, double rating) async {
    try {
      print('''🏁 Starting rating process:
    Worker ID: $workerId
    Order ID: $orderId
    Rating: $rating''');

      // Validate worker document existence
      final workerDoc = await _firebaseFirestore.collection('workers').doc(workerId).get();
      print('📦 Worker document exists: ${workerDoc.exists}');

      if (workerDoc.exists) {
        // Get the current ratings array safely
        List<dynamic> currentRatings = workerDoc.data()!.containsKey('ratings')
            ? List<dynamic>.from(workerDoc['ratings'])
            : [];

        // Add the new rating (allowing duplicates)
        currentRatings.add(rating);

        // Update worker ratings
        print("⬆ Attempting worker rating update...");
        await _firebaseFirestore.collection('workers').doc(workerId).update({
          "ratings": currentRatings,
        });
        print("✅ Worker ratings updated successfully");
      } else {
        print("⚠ Worker document does not exist. Skipping rating update.");
      }

      // Validate order document existence
      final orderDoc = await _firebaseFirestore.collection('orders').doc(orderId).get();
      print('📦 Order document exists: ${orderDoc.exists}');

      if (orderDoc.exists) {
        // Update order rated status
        print("⬆ Attempting order status update...");
        await _firebaseFirestore.collection('orders').doc(orderId).update({
          "rated": true,
        });
        print("✅ Order status updated successfully");
      } else {
        print("⚠ Order document does not exist. Skipping status update.");
      }

    } on FirebaseException catch (e) {
      print('''🔥 Firestore Error:
    Code: ${e.code}
    Message: ${e.message}
    Stack: ${e.stackTrace}''');
    } catch (e, stack) {
      print('''🚨 Unexpected error:
    Error: $e
    Stack: $stack''');
    }
  }

}
