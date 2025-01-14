import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/layout_cubit/layout_state.dart';
import 'package:ecommerceapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerceapp/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ecommerceapp/layout_cubit/layout_cubit.dart';
import '../models/item_model.dart';


class LayoutScreen extends StatelessWidget {
  LayoutScreen({super.key});
final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    LayoutCubit cubit = LayoutCubit.get(context);
    cubit.currentIndex;
    return StreamProvider< List<ItemModel>?>.value(
      value: DatabaseService().Products,
        initialData: null,
    child: Scaffold(
      bottomNavigationBar: BlocBuilder<LayoutCubit,LayoutStates>(
          builder: (context,state) {
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
          }
      ),
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            'shopIn',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        actions: <Widget>[
          //logout button
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: ()async {
              await _auth.signOut();
            },
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<LayoutCubit,LayoutStates>(
        builder: (context,state) {
          return cubit.screens[cubit.currentIndex];
        }
      ),
    ));
  }
}

