import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRepository {
  final FirebaseFirestore _firestore;

  ServiceRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<String>> fetchWorkerProfessions(String userId) async {
    try {
      final doc = await _firestore.collection('workers').doc(userId).get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey('professions')) {
          return List<String>.from(data['professions']);
        }
      }
    } catch (e) {
      print('Error fetching worker professions: $e');
    }
    return [];
  }
}
