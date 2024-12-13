import 'package:ecommerceapp/layout_cubit/layout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerceapp/layout_cubit/layout_cubit.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LayoutCubit cubit = LayoutCubit.get(context);
    cubit.currentIndex;
    return Scaffold(
      bottomNavigationBar:
          BlocBuilder<LayoutCubit, LayoutStates>(builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (int index) {
              cubit.changeCurrentIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favourites',
              ),
            ],
          ),
        );
      }),
      appBar: AppBar(
        elevation: 0,
        //backgroundColor: Colors.transparent,
        // backgroundColor: Colors.cyan,

        title: const Center(
          child: Text(
            'shopIn',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<LayoutCubit, LayoutStates>(builder: (context, state) {
        return cubit.screens[cubit.currentIndex];
      }),
    );
  }
}
