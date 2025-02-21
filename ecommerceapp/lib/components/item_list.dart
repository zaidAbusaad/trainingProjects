import 'package:ecommerceapp/components/item_card.dart';
import 'package:ecommerceapp/list_cubit/product_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/item_model.dart';

class ItemList extends StatelessWidget {
   const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit=  ProductCubit.get(context);
    return  SizedBox(
      height: 250,
      child: ListView.builder(

        itemCount: cubit.items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
        return ItemCard(items:cubit.items[index]);
      },),

    );
  }
}
