import 'package:ecommerceapp/layout_cubit/layout_state.dart';
import 'package:ecommerceapp/screens/favourite_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/cart_screen.dart';
import '../screens/home_page.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(InitialLayoutState());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex=0;
  List<Widget> screens = [
    const HomePage(),
    const CartScreen(),
     const FavouriteItemsScreen(),

  ];
  List<Widget>favourites=[];

  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(SuccessChangeIndexState());
  }
}