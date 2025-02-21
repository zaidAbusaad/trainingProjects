import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project/screensCutomers/orders_screen.dart';


import 'package:grad_project/screensCutomers/home_screen.dart';
import 'package:grad_project/screens/profile_screen.dart';
import 'package:grad_project/screensCutomers/pending_requests_screen.dart';
import 'package:grad_project/screensWorkers/home_screen_worker.dart';
import 'package:grad_project/screensWorkers/offers_screen.dart';
import 'package:grad_project/state_management/cubits/layout_cubit/layout_states.dart';

import '../../../screensWorkers/orders_workers_screen.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(InitialLayoutStates());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex=0;

  List<Widget> screens=[
    const HomeScreen(),
    PendingRequestsScreen(),
    OrdersScreen(),
     ProfileScreen(isWorker: false,),
  ];
  List<Widget> screens2=[
    const HomeScreenWorker(),
    OffersScreen(),
    OrdersWorkersScreen(),
     ProfileScreen(isWorker: true,),
  ];

  void ChangeCurrentIndex(int index)
  {
    currentIndex=index;

    emit(SuccessChangeIndex());
  }
}
