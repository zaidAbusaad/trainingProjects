import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grad_project/models/Request_offer_worker_model.dart';
import 'package:grad_project/models/offer_worker_model.dart';
import 'package:grad_project/repositories/accepted_offers_repository.dart';
import 'package:grad_project/repositories/accepted_offersworker_repository.dart';
import 'package:grad_project/repositories/offer_repository.dart';
import 'package:provider/provider.dart';

import '../../models/customer_order.dart';
import '../../models/offer_model.dart';

class OfferProvider extends ChangeNotifier {
  final OfferRepository _repository;
  final AcceptedOfferRepository _orderRep;

  OfferProvider(this._repository, this._orderRep, this._workerRepo);

  bool _isCreatingOffer = false;

  bool get isCreatingOffer => _isCreatingOffer;
  String _statusMessage = '';

  String get statusMessage => _statusMessage;

  Future<void> createOffer(String requestId, double price, String description,
      String currentUserId) async {
    _isCreatingOffer = true;
    _statusMessage = '';
    notifyListeners();
    try {
      // Pass currentUserId to the service to associate the offer with the user
      await _repository.createOffer(
        requestId: requestId,
        price: price,
        description: description,
        currentUserId: currentUserId,
      ); // Call the service method
      if (_repository.alreadyOffered == true) {
        _statusMessage = 'cant make more than one offer';
      } else {
        _statusMessage = 'Offer submitted successfully!';
      }
    } catch (error) {
      _statusMessage = 'Failed to submit offer. Please try again.';
      print(error);
    } finally {
      _isCreatingOffer = false;
      notifyListeners();
    }
  }

  Future<void> updateOffer({
    required String requestId,
    required double price,
    required String description,
  }) async {
    try {
      await _repository.updateOffer(
        requestId: requestId,
        price: price,
        description: description,
      );
      // Optionally, update internal state after successful update
      notifyListeners(); // Notify listeners about the update
    } catch (error) {
      throw error; // Handle the error accordingly
    }
  }

  Future<void> setPending() async {
    _repository.setPending();
  }

  List<OfferWorkerModel> _offersWithWorkers = [];
  List<OfferWorkerModel> _offers = [];
  bool _isLoading = false;
  String? _error;

  List<OfferWorkerModel> get offersWithWorkers => _offersWithWorkers;

  bool get isLoading => _isLoading;

  String? get error => _error;

  StreamSubscription? _subscription;

  Future<void> fetchOffers(String requestId) async {
    _subscription?.cancel();
    _isLoading = true;
    _error = null;
    notifyListeners();

    print('🔄 Provider: Starting fetch for request: $requestId');

    _subscription = _repository.getOffersWithWorkers(requestId).listen(
      (offers) {
        print('✅ Provider: Received ${offers.length} offers');
        _offersWithWorkers = offers;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        print('❌ Provider error: ${e.toString()}');
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> updateOfferStatus(
      {required String offerId,
      required String status,
      required String requestId}) async {
    try {
      if (status == 'rejected') {
        await _repository.rejectOffer(offerId);
      } else {
        await _repository.acceptOffer(offerId, requestId);
        await _orderRep.moveAcceptedOfferToOrders(offerId);
      }

      notifyListeners();
      // }
    } catch (e) {
      print("Error updating offer status: $e");
    }
  }

  List<RequestOfferWorker> _orderWithWorkers = [];

  List<RequestOfferWorker> get orderWithWorkers => _orderWithWorkers;

  Future<void> fetchOrders() async {
    try {
      final offers = await _orderRep.fetchOngoingCustomerOrders();
      _orderWithWorkers = offers;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error fetching offers: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRequestAndRelatedData(String requestId) async {
    await _orderRep.deleteRequestAndRelatedData(requestId);
    notifyListeners(); // Notify UI about the update
  }
  final AcceptedOfferWorkerRepository _workerRepo;
  List<CustomerOrderModel> _customerOrders = [];
  List<CustomerOrderModel> get customerOrders => _customerOrders;


  Future<void> fetchCustomerOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print("🟡 Fetching customer orders...");
      _customerOrders = await _workerRepo.fetchCustomerOrders();

      print("✅ Orders Fetched: ${_customerOrders.length}");
    } catch (e) {
      _error = 'Failed to load orders';
      print('🔥 Provider Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Set<String> _shownOrders = {}; // To prevent duplicate popups
// In OfferProvider
  Stream<List<Map<String, dynamic>>> getOrderCompletionStream(String customerId) {
    return _workerRepo.listenForOrderCompletion(customerId);
  }

  bool isOrderShown(String orderId) => _shownOrders.contains(orderId);

  void markOrderAsShown(String orderId) {
    _shownOrders.add(orderId);
  }

  void unmarkOrderAsShown(String orderId) {
    _shownOrders.remove(orderId);
  }


  // void listenForOrderCompletion(String customerId, BuildContext context) {
  //   print("🔍 Listening for order completion for customerId: $customerId");
  //
  //   _workerRepo.listenForOrderCompletion(customerId).listen((orders) {
  //     print("📩 New completed orders detected: ${orders.length}");
  //
  //     for (var order in orders) {
  //       final orderId = order["docId"];
  //       final workerId = order["workerId"];
  //       final isRated = order["rated"] ?? false; // ✅ Check if rated (default false)
  //
  //       print("📝 Checking order: $orderId, status=${order["status"]}, rated=$isRated");
  //
  //       // Check if order is completed, not rated, and not previously shown
  //       if (order["status"] == "completed" && !isRated && !_shownOrders.contains(orderId)) {
  //         print("✅ Showing rating popup for Order: $orderId");
  //
  //         _shownOrders.add(orderId); // Mark order as shown to avoid multiple popups
  //         showRatingPopup(context, orderId, workerId);
  //       } else {
  //         // Enhanced debug output to understand why the condition is not met
  //         print("❌ Condition Not Met: status=${order["status"]}, rated=$isRated, docId=$orderId, shownOrders=${_shownOrders.contains(orderId)}");
  //       }
  //     }
  //   });
  // }



  void showRatingPopup(BuildContext context, String orderDocId, String workerId) {
    double _currentRating = 3.0; // Define outside StatefulBuilder

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Rate Your Worker"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("How was your experience?"),
                  Slider(
                    value: _currentRating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _currentRating.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _currentRating = value; // Now correctly updates
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Skip"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _workerRepo.rateWorker(workerId, orderDocId, _currentRating);
                    Navigator.pop(context);
                  },
                  child: Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Future<void> markOrderAsCompleted(String orderId) async {
    await _workerRepo.markOrderAsCompleted(orderId);
  }

}
