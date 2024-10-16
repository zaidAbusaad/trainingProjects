import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project/layout_cubit/layout_cubit.dart';

import '../layout_cubit/layout_states.dart';
import 'home_screen.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LayoutCubit cubit = LayoutCubit.get(context);


    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          // Reduces the width of the Row to its children
          children: [
            const Text(
              'facebook',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(
              flex: 1,
            ), // Space between text and first button
            Wrap(
              spacing: 0, // No space between the buttons
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.zero,
                    // No padding
                    minimumSize: Size(40, 40),
                    // Minimal size to keep the icon visible
                    backgroundColor: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.zero,
                    // No padding
                    minimumSize: Size(40, 40),
                    // Minimal size to keep the icon visible
                    backgroundColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.telegram,
                    size: 40,
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.zero,
                    // No padding
                    minimumSize: Size(40, 40),
                    // Minimal size to keep the icon visible
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: const TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.home_filled,
                color: Colors.blue,
              ),
            ),
            Tab(icon: Icon(Icons.video_call_outlined)),
            Tab(icon: Icon(Icons.people_outline)),
            Tab(icon: Icon(Icons.shopping_cart_outlined)),
            Tab(icon: Icon(Icons.notifications_none_outlined)),
            Tab(icon: Icon(Icons.menu)),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<LayoutCubit, LayoutStates>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (int index) {
                cubit.ChangeCurrentIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
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
        return cubit.screens[cubit.currentIndex];
      }),
    );
  }
}
