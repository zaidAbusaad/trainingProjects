import 'package:ecommerceapp/list_cubit/product_cubit.dart';
import 'package:ecommerceapp/list_cubit/product_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/item_model.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.items});

  final ItemModel items;
  @override
  Widget build(BuildContext context) {
    ProductCubit cubit = ProductCubit.get(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 125,
            width: 120,
            child: Image.asset(
              items.imageUrl,
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(items.itemName),
                  const Text('The size'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             '\$${ items.price}',
                            ),
                            BlocBuilder<ProductCubit,ProductStates>(

                              builder: (context,state) {
                                return Text('Total: \$${items.price * items.qty}');
                              }
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              cubit.decrement(items);
                            },
                            icon:  BlocBuilder<ProductCubit,ProductStates>(
                              builder: (context,state) {
                                return Icon(items.qty==1 ? Icons.delete_outline : Icons.remove);
                              }
                            ),
                          ),
                           BlocBuilder<ProductCubit,ProductStates>(
                             builder: (context,state) {
                               return Text(
                                 items.qty.toString(),
                                                         );
                             }
                           ),
                          IconButton(
                            onPressed: () {
                              cubit.increment(items);
                            },
                            icon:  const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
