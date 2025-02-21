import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestModel {
  final String? title;
  final String? description;
  final LatLng? location;
  final List<String>? images; // CHANGE from List<File>? to List<String>?
  final String? video; // Store video URL as String, not File
  final String? field;

  RequestModel({
    this.title,
    this.description,
    this.location,
    this.images,
    this.video,
    this.field,
  });

  // Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location != null
          ? {'latitude': location!.latitude, 'longitude': location!.longitude}
          : null,
      'images': images ?? [], // Store image URLs as List<String>
      'video': video ?? '', // Store video URL as String
      'field': field,
    };
  }

  // Convert Firestore map to RequestModel
  factory RequestModel.fromMap(Map<String, dynamic> data) {
    return RequestModel(
      title: data['title'] as String?,
      description: data['description'] as String?,
      location: data['location'] != null
          ? LatLng(data['location']['latitude'], data['location']['longitude'])
          : null,
      images: (data['images'] as List<dynamic>?)?.map((item) => item.toString()).toList(),
      video: data['video'] != null ? data['video'] as String : null, // Store video as String
      field: data['field'] as String?,
    );
  }
}
