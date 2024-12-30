import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RequestModel {
  final String? title; // Request title
  final String? description; // Detailed description
  final LatLng? location; // Latitude and longitude
  final List<File>? images; // List of selected image files
  final File? video; // Selected video file

  RequestModel({
    this.title,
    this.description,
    this.location,
    this.images,
    this.video,
  });

  // Convert to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location != null
          ? {'latitude': location!.latitude, 'longitude': location!.longitude}
          : null,
      'images': [], // Placeholder, will be updated after uploading
      'video': '', // Placeholder, will be updated after uploading
    };
  }

  // Firebase: Save the request to Firestore and upload files
  Future<void> saveToFirebase() async {
    try {
      // Step 1: Save metadata to Firestore
      final docRef = FirebaseFirestore.instance.collection('requests').doc();
      Map<String, dynamic> requestData = toMap();
      await docRef.set(requestData);

      // Step 2: Upload images to Firebase Storage
      if (images != null && images!.isNotEmpty) {
        List<String> imageUrls = [];
        for (var image in images!) {
          String imageUrl = await _uploadFileToStorage(
              'requests/${docRef.id}/images/${image.path.split('/').last}', image);
          imageUrls.add(imageUrl);
        }
        await docRef.update({'images': imageUrls}); // Update Firestore with URLs
      }

      // Step 3: Upload video to Firebase Storage
      if (video != null) {
        String videoUrl = await _uploadFileToStorage(
            'requests/${docRef.id}/video/${video!.path.split('/').last}', video!);
        await docRef.update({'video': videoUrl}); // Update Firestore with URL
      }

      print("Request successfully saved to Firebase with ID: ${docRef.id}");
    } catch (e) {
      print("Error saving request to Firebase: $e");
    }
  }

  // Helper: Upload files to Firebase Storage
  Future<String> _uploadFileToStorage(String path, File file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(path);
      final uploadTask = await storageRef.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading file to Firebase Storage: $e");
      throw e;
    }
  }
}
