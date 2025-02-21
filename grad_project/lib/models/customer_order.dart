import 'package:grad_project/models/request_model.dart';
import 'package:grad_project/models/user_model.dart';

import 'offer_model.dart';

class CustomerOrderModel {
  final String orderId;
  final Offer offer;
  final RequestModel request;
  final UserModel customer;

  CustomerOrderModel({
    required this.orderId,
    required this.offer,
    required this.request,
    required this.customer,
  });
}
