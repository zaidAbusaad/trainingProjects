import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/header.dart';
import 'package:grad_project/repositories/offer_repository.dart';
import 'package:grad_project/screens/singel_order_screen.dart';
import 'package:provider/provider.dart';

import '../repositories/accepted_offers_repository.dart';
import '../state_management/providers/offer_provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late StreamSubscription _subscription;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<OfferProvider>(context, listen: false);
    final customerId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _subscription = provider.getOrderCompletionStream(customerId).listen((orders) {
      for (var order in orders) {
        final orderId = order["docId"];
        final workerId = order["workerId"];
        final isRated = order["rated"] ?? false;

        if (order["status"] == "completed" && !isRated && !provider.isOrderShown(orderId)) {
          provider.markOrderAsShown(orderId);
          if (mounted) { // Check if widget is still mounted
            provider.showRatingPopup(context, orderId, workerId);
          } else {
            provider.unmarkOrderAsShown(orderId); // Ensure cleanup if not mounted
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Header(title: "Ongoing Orders", backBtn: false),
          Expanded(child: AcceptedOffersScreen()),
        ],
      ),
    );
  }
}

class AcceptedOffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OfferProvider>(context, listen: false);
    provider.fetchOrders(); // Fetch the offers when the screen is initialized

    return Consumer<OfferProvider>(
      builder: (context, provider, child) {
      //  provider.listenForOrderCompletion(FirebaseAuth.instance.currentUser?.uid ?? '',context);
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.error?.isNotEmpty ?? false) {
          return Center(child: Text('Error: ${provider.error}'));
        }

        if (provider.orderWithWorkers == null || provider.orderWithWorkers!.isEmpty) {
          return Center(
            child: Text(
              'No accepted offers found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: provider.orderWithWorkers.length,
          itemBuilder: (context, index) {
            final offerWithWorker = provider.orderWithWorkers[index];
            final offer = offerWithWorker.offer;
            final worker = offerWithWorker.worker;
            final request = offerWithWorker.request;

            // Handling images
            final List<String> images = List<String>.from(request.images ?? []);
            final String? firstImage = images.isNotEmpty ? images[0] : null;

            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleOrderScreen(data: offerWithWorker,),
                    ),
                  );
                },
              child: Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      if (firstImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            firstImage,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[400],
                              size: 40,
                            ),
                          ),
                        ),

                      SizedBox(height: 16),

                      // Title (Request Title)
                      Text(
                        request.title ?? "No Title",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      // Description (Truncated)
                      Text(
                        request.description ?? "No description available.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: 16),

                      // Field (From Request Model)
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            color: Colors.blue,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            request.field ?? "No Field Specified",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Worker Name
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            worker.name ?? "No Worker",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Price and Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Text(
                            "\$${offer.price?.toStringAsFixed(2) ?? "0.00"}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),


                          Chip(
                            label: Text(
                              offer.status == "accepted" ? "ONGOING": "CANCELED",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: offer.status == "accepted" ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
