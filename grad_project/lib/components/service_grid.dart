import 'package:flutter/material.dart';
import 'package:grad_project/components/service_card.dart';
import 'package:grad_project/home_cubit/home_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication

class ServiceGrid extends StatelessWidget {
  final bool isCustomer; // Boolean to determine user role

  const ServiceGrid({
    super.key,
    required this.isCustomer,
  });

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    // Get the current user's ID
    final currentUser = FirebaseAuth.instance.currentUser;

    // If the user is not authenticated, show an error
    if (currentUser == null) {
      return const Center(child: Text('User not authenticated'));
    }

    final userId = currentUser.uid; // Get the current user's ID

    // If the user is a customer, show all services
    if (isCustomer) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(cubit.services.length, (index) {
          return ServiceCard(field: cubit.services[index],isWorker: false,);
        }),
      );
    }

    // If the user is a worker, fetch their professions
    return FutureBuilder<List<String>>(
      future: _fetchProfessions(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching professions'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No professions found'));
        }

        // Filter services based on professions
        final workerProfessions = snapshot.data!;
        final filteredServices = cubit.services.where((service) {
          // Compare the profession (fieldName) with worker professions
          return workerProfessions.contains(service.profession);
        }).toList();


        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(filteredServices.length, (index) {
            return ServiceCard(field: filteredServices[index],isWorker: true,);
          }),
        );
      },
    );
  }

  // Function to fetch professions for the worker from Firestore
  Future<List<String>> _fetchProfessions(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('workers') // Firestore collection
          .doc(userId)           // Document ID based on user ID
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey('professions')) {
          // Fetch and return the professions field as a list of strings
          return List<String>.from(data['professions']);
        }
      }
    } catch (e) {
      print('Error fetching worker professions: $e');
    }
    return [];
  }
}
