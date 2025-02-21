import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state_management/cubits/layout_cubit/layout_cubit.dart';
import '../state_management/cubits/layout_cubit/layout_states.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LayoutCubit cubit = LayoutCubit.get(context);


    return Scaffold(



      bottomNavigationBar:
      BlocBuilder<LayoutCubit, LayoutStates>(
        builder: (context, state) {
          return BottomNavigationBar(
            backgroundColor: Colors.blue,
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (int index) {
              cubit.ChangeCurrentIndex(index);
            },
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.white,
            items:  const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home,color: Colors.white,),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.request_page),
                label: 'Requests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_offer,color: Colors.white,),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'profile',
              ),

            ],
          );
        },
      ),
      body: BlocBuilder<LayoutCubit, LayoutStates>(builder: (context, state) {
        return cubit.screens[cubit.currentIndex];
      }),
    );
  }
}
