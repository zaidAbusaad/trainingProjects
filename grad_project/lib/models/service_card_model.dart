import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceCardModel {
  final String fieldName;
  final Icon fieldIcon;
  String? profession;

  ServiceCardModel({required this.fieldIcon, required this.fieldName, this.profession});
}
