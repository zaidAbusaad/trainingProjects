import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Customers');

  FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: "gs://gradproject-7e0c9.firebasestorage.app");




  // Method to upload media (images and video) to Firebase Storage


  // Method to save request data (title, description, images, video, location) to Firestore
  Future<void> saveRequestData({
    required String title,
    required String description,
    required LatLng location,
    required List<String> images,
    required String  video,
    required bool status,
  }) async {
    try {
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
          'status':status
        });

        print("Request data saved successfully under user $uid!");
      } else {
        print("Error: User ID is null.");
      }
    } catch (e) {
      print("Error saving request data: $e");
    }
  }


  Future<void> saveRequestData_request({
    required String title,
    required String description,
    required String service,
    required LatLng location,
    required List<String> images,
    required String  video,
    required String userId,
    required bool status,
  }) async {
    try {
      // Check if uid is not null before proceeding
      if (uid != null) {
        // Reference to the user's document in the Customers collection
        DocumentReference userDoc = userCollection.doc(uid);


        final CollectionReference requestCollection = FirebaseFirestore.instance.collection('Requests');

        // Save the request data to the user's Requests subcollection
        await requestCollection.add({
          'title': title,
          'description': description,
          'location': {'latitude': location.latitude, 'longitude': location.longitude},
          'images': images,
          'video': video,
          'createdAt': FieldValue.serverTimestamp(),
          'userId': uid,
          'service': service,
          'status':status


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



  // Method to upload media (images and video) to Firebase Storage
  Future<String> uploadMediaToStorage(File mediaFile, String folderPath) async {
    // Create a unique name for the file
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${mediaFile.path.split('/').last}';
    try {
      // Reference to Firebase Storage with simplified folder structure
      final storageRef = FirebaseStorage.instance.ref().child('$folderPath/$fileName');

      // Upload the file
      print('Uploading file to: $folderPath/$fileName');
      await storageRef.putFile(mediaFile);

      // Get the file's download URL
      String downloadUrl = await storageRef.getDownloadURL();
      print('Uploaded file to $folderPath, download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print("Error uploading file to $folderPath: $e");
      return '';
    }
  }


  Future<void> uploadFile(String localPath) async {
    try {
      // Create a File object
      File file = File(localPath);

      // Check if file exists
      if (!file.existsSync()) {
        print('File does not exist: ${file.path}');
        return;
      }
      print('File exists: ${file.path}');

      // Define Firebase Storage path
      String uid = FirebaseAuth.instance.currentUser!.uid; // Ensure user is authenticated
      String firebasePath = 'Users/$uid/Images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      print('Uploading file to Firebase path: $firebasePath');

      // Upload to Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child(firebasePath);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('File uploaded successfully. Download URL: $downloadUrl');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }


}


