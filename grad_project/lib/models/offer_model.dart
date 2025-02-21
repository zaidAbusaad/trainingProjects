import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final String id;
  final String requestId;
  final String userId;
  final double price;
  final String description;
  final DateTime createdAt;
  final String? status;

  Offer({
    required this.id,
    required this.requestId,
    required this.userId,
    required this.price,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'userId': userId,
      'price': price,
      'description': description,
      'createdAt': createdAt,
      'status': status,
    };
  }

  factory Offer.fromMap(Map<String, dynamic> map, String id) {
    return Offer(
      id: id,
      requestId: map['requestId'] as String,
      userId: map['userId'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      createdAt: _parseTimestamp(map['createdAt']),
      status:  map['status'] as String,
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is DateTime) {
      return timestamp;
    } else {
      throw FormatException('Invalid timestamp: $timestamp');
    }
  }
}