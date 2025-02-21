import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/state_management/cubits/home_cubit/home_cubit.dart';

import '../models/service_card_model.dart';

import 'service_card.dart';

class ServiceGrid extends StatelessWidget {
  final bool isCustomer;

  const ServiceGrid({super.key, required this.isCustomer});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('User not authenticated'));
    }

    if (isCustomer) {
      return _buildGridView(cubit.services, isWorker: false);
    }

    return FutureBuilder<List<String>>(
      future: cubit.fetchWorkerProfessions(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching professions'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No professions found'));
        }

        final workerProfessions = snapshot.data!;

        final filteredServices = cubit.services.where((service) {
          return workerProfessions.contains(service.profession);
        }).toList();

        return _buildGridView(filteredServices, isWorker: true);
      },
    );
  }

  Widget _buildGridView(List<ServiceCardModel> services, {required bool isWorker}) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: services.map((service) {
        return ServiceCard(field: service, isWorker: isWorker);
      }).toList(),
    );
  }
}
