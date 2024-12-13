import 'package:flutter/material.dart';
import 'package:grad_project/components/service_card.dart';
import 'package:grad_project/home_cubit/home_cubit.dart';

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(cubit.services.length, (index){
        return ServiceCard(field: cubit.services[index]);
      }),
    );
  }
}
