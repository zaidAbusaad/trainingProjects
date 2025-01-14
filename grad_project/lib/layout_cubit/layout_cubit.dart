import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project/layout_cubit/layout_states.dart';

import '../screensCutomers/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screensWorkers/home_screen_worker.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(InitialLayoutStates());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex=0;

  List<Widget> screens=[
    const HomeScreen(),
     ProfileScreen(isWorker: false,),
  ];
  List<Widget> screens2=[
    const HomeScreenWorker(),
     ProfileScreen(isWorker: true,),
  ];
  void ChangeCurrentIndex(int index)
  {
    currentIndex=index;

    emit(SuccessChangeIndex());
  }
}
