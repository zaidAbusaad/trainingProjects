import 'package:flutter/material.dart';
import 'package:grad_project/screensWorkers/single_order_worker_screen.dart';
import 'package:provider/provider.dart';
import '../screens/singel_order_screen.dart';
import '../state_management/providers/offer_provider.dart';
import '../components/header.dart';


class OrdersWorkersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(title: "Ongoing Orders", backBtn: false),
          Expanded(child: CustomerOrdersScreen()),
        ],
      ),
    );
  }
}

class CustomerOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OfferProvider>(context, listen: false);
    provider.fetchCustomerOrders(); // ✅ Fetch customer orders

    return Consumer<OfferProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.error?.isNotEmpty ?? false) {
          return Center(
            child: Text(
              'Error: ${provider.error}',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        if (provider.customerOrders == null || provider.customerOrders.isEmpty) {
          return Center(
            child: Text(
              'No accepted orders found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: provider.customerOrders.length,
          itemBuilder: (context, index) {
            final order = provider.customerOrders[index];
            final request = order.request;
            final customer = order.customer;
            final offer = order.offer;

            // ✅ Extract first image if available
            final List<String> images = List<String>.from(request.images ?? []);
            final String? firstImage = images.isNotEmpty ? images[0] : null;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => SingleOrderWorkerScreen(data: order),
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
                      // ✅ Image Section
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
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(Icons.broken_image, color: Colors.grey[400]),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        _buildPlaceholder(),

                      SizedBox(height: 16),

                      // ✅ Request Title
                      _buildTitle(request.title ?? "No Title"),

                      SizedBox(height: 8),

                      // ✅ Request Description (Truncated)
                      _buildDescription(request.description ?? "No description available."),

                      SizedBox(height: 16),


                      _buildFieldRow(request.field ?? "No Field Specified"),

                      SizedBox(height: 16),


                      _buildCustomerRow(customer.name ?? "No Customer"),

                      SizedBox(height: 16),


                      _buildPriceAndStatus(offer.price, offer.status),
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


  Widget _buildPlaceholder() {
    return Container(
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
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 14,
      ),
    );
  }

  Widget _buildFieldRow(String field) {
    return Row(
      children: [
        Icon(
          Icons.category,
          color: Colors.blue,
          size: 18,
        ),
        SizedBox(width: 8),
        Text(
          field,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerRow(String customerName) {
    return Row(
      children: [
        Icon(
          Icons.person,
          color: Colors.blue,
          size: 18,
        ),
        SizedBox(width: 8),
        Text(
          customerName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndStatus(double? price, String? status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(
          "\$${price?.toStringAsFixed(2) ?? "0.00"}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),


        Chip(
          label: Text(
            status == "accepted" ? "ONGOING": "CANCELED",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          backgroundColor: status == "accepted" ? Colors.green : Colors.red,
        ),
      ],
    );
  }
}
