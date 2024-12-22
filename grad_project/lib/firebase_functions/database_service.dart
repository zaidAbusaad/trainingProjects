import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('Customers');


  // Method for updating user data
  Future<void> updateUserData(String name, String email, int age, String phoneNumber) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'age' : age,
      'phoneNumber':phoneNumber,

    });
  }

  Future<void> fetchServicesWithIds() async {
    final firestore = FirebaseFirestore.instance;
    final servicesCollection = firestore.collection('services');

    try {
      final querySnapshot = await servicesCollection.get();
      for (var doc in querySnapshot.docs) {
        String serviceId = doc.id;
        Map<String, dynamic> serviceData = doc.data();

        print('Service ID: $serviceId');
        print('Service Data: $serviceData');
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }



}