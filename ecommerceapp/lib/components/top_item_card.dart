import 'package:ecommerceapp/models/item_model.dart';
import 'package:flutter/material.dart';

import '../list_cubit/product_cubit.dart';
import '../screens/item_screen.dart';

class TopItemCard extends StatelessWidget {
  const TopItemCard({super.key, required this.items});
 final ItemModel items;
  @override


  Widget build(BuildContext context) {
    ProductCubit cubit=ProductCubit.get(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemScreen(item: items,)),
                  );
                },
                child: Container(
                    width: 320,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      image:  DecorationImage(
                          image: AssetImage(
                            items.imageUrl,
                          ),
                          alignment: Alignment.centerLeft),
                    ),
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 160,
                      height: 150,
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(items.itemName),
                           Text('\$${items.price}'),
                          Container(
                            height: 50,
                            width: 100,
                            child: FloatingActionButton(
                              onPressed: () {
                                cubit.addItem(items);
                              },
                              backgroundColor: Colors.black,
                              child: const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 1.50),
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Add To Cart",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
