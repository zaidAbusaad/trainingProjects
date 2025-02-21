import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project/models/service_card_model.dart';

import 'package:grad_project/repositories/service_repository.dart';
import 'package:grad_project/state_management/cubits/home_cubit/home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final ServiceRepository _repository;

  HomeCubit(this._repository) : super(InitialLayoutStates());


  static HomeCubit get(BuildContext context) => BlocProvider.of(context);


  final List<ServiceCardModel> services = [
    ServiceCardModel(
      fieldIcon: const Icon(Icons.electric_bolt, color: Colors.blue),
      profession: 'Electrician',
      fieldName: 'Electrical',
    ),
    ServiceCardModel(
      fieldIcon: const Icon(Icons.plumbing, color: Colors.blue),
      profession: 'Plumber',
      fieldName: 'Plumbing',
    ),
    ServiceCardModel(
      fieldIcon: const Icon(Icons.clean_hands, color: Colors.blue),
      profession: 'Cleaner',
      fieldName: 'Cleaning',
    ),
    ServiceCardModel(
      fieldIcon: const Icon(Icons.ac_unit, color: Colors.blue),
      profession: 'AC Technician',
      fieldName: 'AC Technician',
    ),
    ServiceCardModel(
      fieldIcon: const Icon(Icons.format_paint, color: Colors.blue),
      profession: 'Painter',
      fieldName: 'Paint',
    ),
    ServiceCardModel(
      fieldIcon: const Icon(Icons.build, color: Colors.blue),
      profession: 'Renovator',
      fieldName: 'Renovation',
    ),
  ];


  Future<List<String>> fetchWorkerProfessions(String userId) async {
    try {
      emit(LoadingState());
      final professions = await _repository.fetchWorkerProfessions(userId);
      emit(LoadedState());
      return professions;
    } catch (e) {
      emit(ErrorState('Failed to fetch worker professions: $e'));
      return [];
    }
  }
}
