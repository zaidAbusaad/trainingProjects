import 'package:grad_project/models/request_model.dart';
import 'package:grad_project/models/user_model.dart';

import 'offer_model.dart';

class RequestOfferWorker {
  final Offer offer;
  final UserModel worker;
  final RequestModel request;

  RequestOfferWorker({
    required this.request,
    required this.offer,
    UserModel? worker,
  }) : worker = worker ?? UserModel.unknown();
}
