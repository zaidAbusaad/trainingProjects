import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project/layout_cubit/layout_cubit.dart';

import '../layout_cubit/layout_states.dart';

class LayoutScreenWorker extends StatelessWidget {
  const LayoutScreenWorker({super.key});

  @override
  Widget build(BuildContext context) {
    LayoutCubit cubit = LayoutCubit.get(context);


    return Scaffold(
      bottomNavigationBar:
      BlocBuilder<LayoutCubit, LayoutStates>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFDB58),
              borderRadius: BorderRadius.circular(70),


            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.blue,

              currentIndex: cubit.currentIndex,
              onTap: (int index) {
                cubit.ChangeCurrentIndex(index);
              },
              items:  const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home,color: Colors.white,),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'history',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'profile',
                ),

              ],
            ),
          );
        },
      ),
      body: BlocBuilder<LayoutCubit, LayoutStates>(builder: (context, state) {
        return cubit.screens2[cubit.currentIndex];
      }),
    );
  }
}
