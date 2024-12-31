import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RequestModel {
  final String? title; // Request title
  final String? description; // Detailed description
  final LatLng ? location; // Latitude and longitude
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
      'images': images ?? [], // Store image URLs
      'video': video ?? '', // Store video URL
    };
  }


}
