import '../repositories/offer_repository.dart';
//THIS FILE IS CURRENTLY NOT USED ANYWHERE IN THE PROJECT
class OfferService {
  final OfferRepository offerRepository;

  OfferService({required this.offerRepository});

  // Create an offer
  Future<void> createOffer(String requestId, double price, String description,
      String currentUserId) async {
    try {
      await offerRepository.createOffer(
        requestId: requestId,
        price: price,
        description: description,
        currentUserId: currentUserId,
      );
    } catch (e) {
      rethrow; // Handle or log error
    }
  }
}
