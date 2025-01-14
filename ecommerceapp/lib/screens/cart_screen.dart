import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/components/cart_item.dart';
import 'package:ecommerceapp/list_cubit/product_cubit.dart';
import 'package:ecommerceapp/list_cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../models/item_model.dart';
import '../models/user.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final userId = user?.uid; // Get the user ID

    if (userId == null) {
      return Center(
        child: Text('Please log in to view your cart'),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Cart')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Your cart is empty!'));
        }

        // Map the Firestore data into ItemModel objects
        final cartItems = snapshot.data!.docs.map((doc) {
          return ItemModel(
            imageUrl: doc['imageUrl'],
            itemName: doc['itemName'],
            price: doc['price'],
            qty: doc['qty'],
          );
        }).toList();

        return ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            return CartItem(items: cartItems[index]);
            return CartItem(item: cartItems[index]);
          },
        );
      },
    );
  }
}

