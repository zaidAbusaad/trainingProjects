import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../state_management/providers/media_provider.dart';
import '../models/service_card_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../screensCutomers/map_page.dart';
import 'database_service.dart';

// Assuming globalLastTappedLocation is a global variable


class RequestService {
  static Future<void> submitRequest(
      BuildContext context,
      MediaProvider mediaProvider,
      TextEditingController titleController,
      TextEditingController descriptionController,
      ServiceCardModel field,
      ) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    if (titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title and description cannot be empty")));
      return;
    }

    // Use globalLastTappedLocation here
    LatLng? selectedLocation = globalLastTappedLocation;

    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a location on the map")));
      return;
    }

    List<String> imageUrls = [];
    String videoUrl = '';

    final dbService = DatabaseService(uid: userId);
    try {
      for (var image in mediaProvider.selectedImages) {
        String imageUrl = await dbService.uploadMediaToStorage(image, 'Users/$userId/Images');
        if (imageUrl.isNotEmpty) {
          imageUrls.add(imageUrl);
        }
      }

      if (mediaProvider.selectedVideo != null) {
        videoUrl = await dbService.uploadMediaToStorage(mediaProvider.selectedVideo!, 'Users/$userId/Videos');
      }

      await dbService.saveRequestData(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        location: selectedLocation,
        images: imageUrls,
        video: videoUrl,
        status: false,
        field: field.fieldName,
      );

      await dbService.saveRequestData_request(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          location: selectedLocation,
          images: imageUrls,
          video: videoUrl,
          service: '',
          userId: userId,
          status: false,
          field : field.fieldName

      );

      mediaProvider.clearMedia();
      titleController.clear();
      descriptionController.clear();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request submitted successfully!")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to upload: $e")));
    }
  }
}
