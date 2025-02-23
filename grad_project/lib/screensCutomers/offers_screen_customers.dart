import 'package:flutter/material.dart';
import 'package:grad_project/components/header.dart';
import 'package:grad_project/components/offer_dialog.dart';
import 'package:grad_project/models/offer_worker_model.dart';
import 'package:grad_project/models/user_model.dart';
import 'package:provider/provider.dart';
import '../models/offer_model.dart';
import '../state_management/providers/offer_provider.dart';

class OffersScreenCustomers extends StatefulWidget {
  final String requestId;

  const OffersScreenCustomers({
    super.key,
    required this.requestId,
  });

  @override
  State<OffersScreenCustomers> createState() => _OffersScreenCustomersState();
}

class _OffersScreenCustomersState extends State<OffersScreenCustomers> {
  bool _initialFetchDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialFetchDone) {
      _initialFetchDone = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<OfferProvider>().fetchOffers(widget.requestId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OfferProvider>();

    return Scaffold(
      body: Column(
        children: [
          const Header(title: 'Choose your Worker', backBtn: true),
          _buildBody(provider),
        ],
      ),
    );
  }

  Widget _buildBody(OfferProvider provider) {
    print('TEST 1 - Building body'); // Track widget rebuilds

    if (provider.isLoading) {
      print('TEST 2 - Loading state active');
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      print('TEST 3 - Error state: ${provider.error}');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 40),
            Text('Error: ${provider.error!}'),
          ],
        ),
      );
    }

    if (provider.offersWithWorkers.isEmpty) {
      print('TEST 4 - Empty state');
      print('TEST 4a - Request ID: ${widget.requestId}');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_outlined, size: 40),
            const SizedBox(height: 16),
            const Text('No offers available'),
            Text(
              'Request ID: ${widget.requestId}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    print('TEST 5 - Data available');
    print('TEST 5a - Offer count: ${provider.offersWithWorkers.length}');

    return Expanded(
      child: ListView.builder(
        itemCount: provider.offersWithWorkers.length,
        itemBuilder: (context, index) {
          final offer = provider.offersWithWorkers[index];
          return GestureDetector(
            onTap: () {
              showCustomDialog(context,
                  offer: offer.offer, worker: offer.worker);
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Worker Avatar
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blue[100],
                      foregroundColor: Colors.blue[800],
                      child: Text(
                        offer.worker?.name?.substring(0, 1).toUpperCase() ??
                            '?',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Offer Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description
                          Text(
                            offer.offer.description,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          // Price
                          Text(
                            '\$${offer.offer.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          // Worker Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.person_outline, size: 18, color: Colors.grey[600]),

                              SizedBox(width: 4),

                              // ✅ Use Expanded to prevent overflow
                              Expanded(
                                child: Text(
                                  offer.worker?.name ?? 'Unknown Worker',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive text size
                                    color: Colors.grey[700],
                                  ),
                                  overflow: TextOverflow.ellipsis, // Prevents text from overflowing
                                  maxLines: 1, // Ensures single-line text
                                ),
                              ),

                              SizedBox(width: 5),

                              Icon(Icons.star_rate, color: Colors.yellow),

                              // ✅ Wrap rating text inside Flexible to prevent overflow
                              Flexible(
                                child: Text(
                                  'Rate: ${offer.worker.ratings != null && offer.worker.ratings!.isNotEmpty
                                      ? (offer.worker.ratings!.reduce((a, b) => a + b) / offer.worker.ratings!.length).toStringAsFixed(1)
                                      : 'Not Rated'}',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.035, // Responsive font size
                                  ),
                                  overflow: TextOverflow.ellipsis, // Avoids breaking layout
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
