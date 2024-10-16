import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project/layout_cubit/layout_states.dart';
import 'package:grad_project/screens/home_screen.dart';
import 'package:grad_project/screens/profile_screen.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(InitialLayoutStates());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex=0;

  List<Widget> screens=[
    const HomeScreen(),
    const ProfileScreen(),
  ];
  void ChangeCurrentIndex(int index)
  {
    currentIndex=index;

    emit(SuccessChangeIndex());
  }
}
