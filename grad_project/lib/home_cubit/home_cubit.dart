
import 'package:flutter/material.dart';
import 'package:grad_project/models/service_card_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project/home_cubit/home_states.dart';

class HomeCubit extends Cubit<HomeStates>{
  HomeCubit():super(InitialLayoutStates());

  static HomeCubit get(context) => BlocProvider.of(context);

  final List<ServiceCardModel>services=[
    ServiceCardModel(fieldIcon: const Icon(Icons.electric_bolt,color: Colors.blue,), fieldName: 'Electrical'),
    ServiceCardModel(fieldIcon: const Icon(Icons.plumbing,color: Colors.blue,), fieldName: 'Plumbing'),
    ServiceCardModel(fieldIcon: const Icon(Icons.clean_hands,color: Colors.blue,), fieldName: 'Cleaning'),
    ServiceCardModel(fieldIcon: const Icon(Icons.ac_unit,color: Colors.blue,), fieldName: 'AC'),
    ServiceCardModel(fieldIcon: const Icon(Icons.format_paint,color: Colors.blue,), fieldName: 'Paint'),
    ServiceCardModel(fieldIcon: const Icon(Icons.build,color: Colors.blue,), fieldName: 'renovate'),
  ];
}