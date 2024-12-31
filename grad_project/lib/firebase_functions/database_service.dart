import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Customers');

  // Method to upload media (images and video) to Firebase Storage
  Future<String> uploadMediaToStorage(File mediaFile, String mediaType) async {
    // Create a unique name for the file
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.$mediaType';
    try {
      // Reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('uploads/$mediaType/$fileName');

      // Upload the file
      if (mediaFile != null) {
        print('Uploading file to: $storageRef');
        await storageRef.putFile(mediaFile);
      } else {
        print("Error: No file selected");
        return ''; // Or handle appropriately
      }

      // Get the file's download URL
      String downloadUrl = await storageRef.getDownloadURL();
      print('Uploaded $mediaType, download URL: $downloadUrl'); // Debugging line
      return downloadUrl;
    } catch (e) {
      print("Error uploading $mediaType: $e");
      return '';
    }
  }

  // Method to save request data (title, description, images, video, location) to Firestore
  Future<void> saveRequestData({
    required String title,
    required String description,
    required LatLng location,
    required List<String> images,
    required String  video,
  }) async {
    try {
      // Upload images to Firebase Storage and get URLs


      // Check if uid is not null before proceeding
      if (uid != null) {
        // Reference to the user's document in the Customers collection
        DocumentReference userDoc = userCollection.doc(uid);

        // Reference to the Requests subcollection within the user's document
        CollectionReference requestsCollection = userDoc.collection('Requests');

        // Save the request data to the user's Requests subcollection
        await requestsCollection.add({
          'title': title,
          'description': description,
          'location': {'latitude': location.latitude, 'longitude': location.longitude},
          'images': images,
          'video': video,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("Request data saved successfully under user $uid!");
      } else {
        print("Error: User ID is null.");
      }
    } catch (e) {
      print("Error saving request data: $e");
    }
  }

  // Method for updating user data
  Future<void> updateUserData(String name, String email, int age, String phoneNumber) async {
    if (uid != null) {
      return await userCollection.doc(uid).set({
        'name': name,
        'email': email,
        'age': age,
        'phoneNumber': phoneNumber,
      });
    } else {
      print("Error: User ID is null.");
      return Future.error("User ID is null.");
    }
  }

  Future<void> fetchServicesWithIds() async {
    final firestore = FirebaseFirestore.instance;
    final servicesCollection = firestore.collection('services');

    try {
      final querySnapshot = await servicesCollection.get();
      for (var doc in querySnapshot.docs) {
        String serviceId = doc.id;
        Map<String, dynamic> serviceData = doc.data();

        print('Service ID: $serviceId');
        print('Service Data: $serviceData');
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }
}
