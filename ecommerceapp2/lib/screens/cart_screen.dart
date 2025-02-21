import 'package:ecommerceapp/components/cart_item.dart';
import 'package:ecommerceapp/list_cubit/product_cubit.dart';
import 'package:ecommerceapp/list_cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProductCubit cubit= ProductCubit.get(context);

    return BlocBuilder<ProductCubit,ProductStates>(
      buildWhen: (previous, current) => current is DecrementSuccess,
      builder: (context,state) {
        return ListView.builder(
          itemCount: cubit.cartItems.length,
          itemBuilder: (context, index) {
            return CartItem(item: cubit.cartItems[index]);
          },
        );
      }
    );
  }
}
