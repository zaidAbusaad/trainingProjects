import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceCardModel {
  final String fieldName;
  final Icon fieldIcon;
  String? profession;

  ServiceCardModel({required this.fieldIcon, required this.fieldName, this.profession});

  factory ServiceCardModel.fromMap(Map<String, dynamic> data) {
    return ServiceCardModel(
      fieldName: data['fieldName'] ?? '',
      fieldIcon: Icon(
        IconData(data['fieldIcon'] ?? 0xe3af, fontFamily: 'MaterialIcons'),
        color: Colors.blue,
      ),
    );
  }
}
