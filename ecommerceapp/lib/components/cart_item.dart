import 'package:ecommerceapp/list_cubit/product_cubit.dart';
import 'package:ecommerceapp/list_cubit/product_state.dart';
import 'package:ecommerceapp/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.item});

  final ItemModel item;
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
              item.imageUrl,
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.itemName),
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
                             '\$${ item.price}',
                            ),
                            BlocBuilder<ProductCubit,ProductStates>(

                              builder: (context,state) {
                                return Text('Total: \$${item.price * item.qty}');
                              }
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              cubit.decrement(item);
                            },
                            icon:  BlocBuilder<ProductCubit,ProductStates>(
                              builder: (context,state) {
                                return Icon(item.qty==1 ? Icons.delete_outline : Icons.remove);
                              }
                            ),
                          ),
                           BlocBuilder<ProductCubit,ProductStates>(
                             builder: (context,state) {
                               return Text(
                                 item.qty.toString(),
                                                         );
                             }
                           ),
                          IconButton(
                            onPressed: () {
                              cubit.increment(item);
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
