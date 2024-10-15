import 'package:ecommerceapp/list_cubit/product_cubit.dart';
import 'package:ecommerceapp/list_cubit/product_state.dart';
import 'package:ecommerceapp/models/item_model.dart';
import 'package:ecommerceapp/screens/item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.items});

  final ItemModel items;

  @override
  Widget build(BuildContext context) {
    final cubit = ProductCubit.get(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 280,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemScreen(
                                item: items,
                              )),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      items.imageUrl,
                      height: 120,
                      width: double.maxFinite,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<ProductCubit, ProductStates>(
                      builder: (context, state) {
                    return IconButton(
                        onPressed: () {
                          cubit.changeIsFavorite(items);
                        },
                        icon: Icon(
                          items.isFavorite == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: items.isFavorite == true
                              ? Colors.red
                              : Colors.grey,
                        ));
                  }),
                ),
              ],
            ),
            Text(items.itemName),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[350],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '7 colors',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Row(
              children: [
                Text('\$${items.price.toString()}'),
                const Spacer(
                  flex: 1,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  height: 40,
                  width: 40,
                    alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      cubit.addItem(items);
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
