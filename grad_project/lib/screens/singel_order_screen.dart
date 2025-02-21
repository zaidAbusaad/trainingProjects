// Order Details Screen
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/header.dart';
import 'package:grad_project/screensCutomers/orders_screen.dart';
import 'package:grad_project/screensCutomers/layout_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Request_offer_worker_model.dart';
import '../state_management/providers/offer_provider.dart';

class SingleOrderScreen extends StatelessWidget {
  final RequestOfferWorker data;

  const SingleOrderScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final request = data.request;
    final offer = data.offer;
    final worker = data.worker;
    final images = List<String>.from(request.images ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: images.isNotEmpty
                  ? PageView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(Icons.broken_image),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Request Details Section
                  _buildSectionTitle('Service Details'),
                  _buildDetailCard(
                    children: [
                      _buildDetailItem(
                        icon: Icons.title,
                        title: 'Title',
                        value: request.title ?? 'No title available',
                      ),
                      _buildDetailItem(
                        icon: Icons.description,
                        title: 'Description',
                        value:
                            request.description ?? 'No description available',
                      ),
                      _buildDetailItem(
                        icon: Icons.category,
                        title: 'Field',
                        value: request.field ?? 'No field specified',
                      ),
                      GestureDetector(
                        onTap: () {
                          final latitude = request.location!.latitude;
                          final longitude = request.location!.longitude;
                          final googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
                          launchUrl(Uri.parse(googleMapsUrl)); // Open Google Maps
                        },
                        child: Text(
                          'View Location on Map',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Blue to indicate a clickable link
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Offer Details Section
                  _buildSectionTitle('Offer Details'),
                  _buildDetailCard(
                    children: [
                      _buildDetailItem(
                        icon: Icons.attach_money,
                        title: 'Price',
                        value: '\$${offer.price?.toStringAsFixed(2) ?? "0.00"}',
                      ),
                      _buildDetailItem(
                        icon: Icons.description,
                        title: 'Offer Description',
                        value: offer.description != null
                            ? offer.description
                            : 'No descripeion specified',
                      ),
                      _buildDetailItem(
                        icon: Icons.star,
                        title: 'Status',
                        value: offer.status?.toUpperCase() ?? 'PENDING',
                        valueColor: offer.status == "accepted"
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Worker Details Section
                  _buildSectionTitle('Worker Information'),
                  _buildDetailCard(
                    children: [
                      _buildDetailItem(
                        icon: Icons.person,
                        title: 'Worker Name',
                        value: worker.name ?? 'No worker information',
                      ),
                      _buildDetailItem(
                        icon: Icons.calendar_month,
                        title: 'Worker Age',
                        value:
                            worker.age?.toString() ?? 'No worker information',
                      ),
                      _buildDetailItem(
                        icon: Icons.phone,
                        title: 'Worker MobileNumebr',
                        value: worker.phoneNumber?.toString() ??
                            'No worker information',
                      ),
                      _buildDetailItem(
                        icon: Icons.star_rate,
                        title: 'Worker Rating',
                        value:worker.ratings != null && worker.ratings!.isNotEmpty
                            ? (worker.ratings!.reduce((a, b) => a + b) / worker.ratings!.length).toStringAsFixed(1)
                            : 'Not Rated',
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(context, offer.id, offer.requestId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      'Cancel Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
void _showConfirmationDialog(BuildContext context, String offerId, String requestId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Are you sure?"),
        content: Text("Do you really want to cancel this order?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Provider.of<OfferProvider>(context, listen: false)
                  .updateOfferStatus(
                offerId: offerId,
                status: 'rejected',
                requestId: requestId,
              );
              Provider.of<OfferProvider>(context, listen: false)
                  .deleteRequestAndRelatedData(

                requestId,
              );
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.pop(context); // Close alert dialog
                Navigator.pop(context); // Close the current screen
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                    builder: (context) => LayoutScreen(),),);
              });
            },
            child: Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}