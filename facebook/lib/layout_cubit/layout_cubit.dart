import 'package:bloc/bloc.dart';
import 'package:facebook/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates>{
  LayoutCubit(): super(InitialLayoutStates());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex=0;

  List<Widget> screens=[
    const HomeScreen(),
  ];
  void ChangeCurrentIndex(int index){
    currentIndex=index;
    emit(SuccessChangeIndexState());
  }

}