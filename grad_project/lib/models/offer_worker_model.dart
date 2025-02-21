import 'package:grad_project/models/user_model.dart';

import 'offer_model.dart';

class OfferWorkerModel {
  final Offer offer;
  final UserModel worker;

  OfferWorkerModel({
    required this.offer,
    UserModel? worker,
  }) : worker = worker ?? UserModel.unknown();
}