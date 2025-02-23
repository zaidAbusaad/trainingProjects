import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/offer_model.dart';
import '../models/user_model.dart';
import '../repositories/offer_repository.dart';
import '../state_management/providers/offer_provider.dart';

void showOfferDialog(
    {required BuildContext context, required String requestId}) async {
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  OfferRepository _offerRepository =
      OfferRepository(currentUserId: FirebaseAuth.instance.currentUser!.uid);

  var screenWidth = MediaQuery.of(context).size.width;
  var screenHeight = MediaQuery.of(context).size.height;

  bool _isPriceValid = true;
  bool _isDescriptionValid = true;
  String _statusMessage = '';

  String _priceErrorText = '';
  String _descriptionErrorText = '';
  Map<String, dynamic>? existingOffer =
      await _offerRepository.checkRequestForOffer(requestId);

  if (existingOffer != null) {
    _priceController.text = existingOffer['price'].toString();
    _descriptionController.text = existingOffer['description'];
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title:
                Text(existingOffer != null ? 'Update Offer' : 'Submit Offer'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    errorText: _descriptionErrorText.isNotEmpty
                        ? _descriptionErrorText
                        : null,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _descriptionErrorText.isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Price',
                    errorText:
                        _priceErrorText.isNotEmpty ? _priceErrorText : null,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _priceErrorText.isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_statusMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      _statusMessage,
                      style: TextStyle(
                        color: _statusMessage.contains('successfully')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  String description = _descriptionController.text;
                  String price = _priceController.text;

                  bool isValidDescription = description.isNotEmpty;
                  bool isValidPrice = price.isNotEmpty &&
                      double.tryParse(price) != null &&
                      double.tryParse(price)! > 0;

                  setState(() {
                    _descriptionErrorText =
                        isValidDescription ? '' : 'Description is required';
                    _priceErrorText = isValidPrice ? '' : 'Price is required ';
                    _statusMessage = '';
                    _isDescriptionValid = isValidDescription;
                    _isPriceValid = isValidPrice;
                  });

                  if (isValidDescription && isValidPrice) {
                    double parsedPrice = double.parse(price);

                    final offerProvider =
                        Provider.of<OfferProvider>(context, listen: false);
                    String currentUserId =
                        FirebaseAuth.instance.currentUser!.uid;

                    if (existingOffer != null) {
                      await offerProvider.updateOffer(
                        requestId: requestId,
                        price: parsedPrice,
                        description: description,
                      );
                      setState(() {
                        _statusMessage = 'Offer updated successfully!';
                      });
                    } else {
                      await offerProvider.createOffer(
                        requestId,
                        parsedPrice,
                        description,
                        currentUserId,
                      );

                      setState(() {
                        _statusMessage = 'Offer submitted successfully!';
                      });
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Offer submitted successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      _statusMessage = 'Please fill in all fields correctly.';
                    });
                  }
                },
                child: Text(existingOffer != null ? 'Update' : 'Submit'),
              ),
            ],
          );
        },
      );
    },
  );
}

void showCustomDialog(BuildContext context,
    {required Offer offer, required UserModel worker})
{
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth,
                maxHeight: constraints.maxHeight * 0.8,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Offer Details Section
                    _buildSectionHeader('Offer Details'),
                    _buildDetailItem(
                        'Price', '\$${offer.price.toStringAsFixed(2)}'),
                    _buildDetailItem('Description', offer.description),
                    const Divider(height: 30),

                    // Worker Details Section
                    _buildSectionHeader('Worker Information'),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        child: Text(
                          worker.name!.substring(0, 1).toUpperCase(),
                          style: textTheme.titleLarge
                              ?.copyWith(color: theme.primaryColor),
                        ),
                      ),
                      title: Text(
                        worker.name as String,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (worker.phoneNumber != null)
                            _buildContactItem(Icons.phone, worker.phoneNumber!),
                          if (worker.email != null)
                            _buildContactItem(Icons.email, worker.email!),
                          if (worker.ratings != null && worker.ratings!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 5),
                                Text(
                                  (worker.ratings!.reduce((a, b) => a + b) / worker.ratings!.length).toStringAsFixed(1),
                                  style: textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),



                    // if (worker.ratings != null && worker.ratings!.isNotEmpty) ...[
                    //   Text(worker.ratings!.reduce((a, b) => a + b) / worker.ratings!.length).toStringAsFixed(1),
                    // ]


                    const SizedBox(height: 25),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,  // Make the button take equal space
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(color: theme.primaryColor)),
                            onPressed: () {
                             // Provider.of<OfferProvider>(context, listen: false).setPending();
                              Navigator.pop(context);
                            },
                            child:Icon(Icons.cancel_outlined),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.01),
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              WidgetsBinding.instance!.addPostFrameCallback((_) {
                                Provider.of<OfferProvider>(context, listen: false).updateOfferStatus(
                                  offerId: offer.id,
                                  status: 'rejected',
                                  requestId: offer.requestId,
                                );
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              'Decline',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.025, // Adjust font size as needed
                              ),
                              overflow: TextOverflow.ellipsis, // Handle overflow
                              softWrap: true, // Wrap text to prevent cutting off
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.01),
                        Flexible(
                          flex: 1,  // Same as above
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Provider.of<OfferProvider>(context, listen: false).updateOfferStatus(
                                offerId: offer.id,
                                status: 'accepted',
                                requestId: offer.requestId,
                              );
                              Navigator.pop(context);
                              Navigator.pop(context);
                              showOrderConfirmationPopup(context);
                            },
                            child: Text(
                              'Accept Offer',
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.025),
                              overflow: TextOverflow.ellipsis, // Handle overflow
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

// Helper Widgets
Widget _buildSectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    ),
  );
}

Widget _buildDetailItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildContactItem(IconData icon, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(value),
      ],
    ),
  );
}
void showOrderConfirmationPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents closing before timeout
    builder: (context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close popup after 2 sec
      });

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text(
                "Order Created",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
