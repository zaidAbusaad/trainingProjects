import 'package:ecommerceapp/components/top_item_card.dart';
import 'package:flutter/material.dart';
import '../list_cubit/product_cubit.dart';
class TopItemsList extends StatelessWidget {
  const TopItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    ProductCubit cubit = ProductCubit.get(context);
    return  SizedBox(

      height: 180,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:cubit.items.length,
          itemBuilder: (context, index) {
            return  TopItemCard(items: cubit.items[index],);
          }),
    );

  }
}
