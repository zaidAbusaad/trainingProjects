import 'package:ecommerceapp/components/all_items_card.dart';
import 'package:flutter/material.dart';



import '../models/item_model.dart';
class AllItemsScreen extends StatelessWidget {
       AllItemsScreen({super.key});
      final List<ItemModel>items=[
      ItemModel(imageUrl: 'assets/images/img3.jpeg', itemName: 'Puma Running ', price: 100),
      ItemModel(imageUrl: 'assets/images/img5.jpeg', itemName: 'Nike Running', price: 90),
      ItemModel(imageUrl: 'assets/images/img6.jpeg', itemName: 'tennis shoes', price: 40),
      ItemModel(imageUrl: 'assets/images/img1.jpeg', itemName: 'Nike Jordan 1\'s', price: 150),
      ItemModel(imageUrl: 'assets/images/img2.jpeg', itemName: 'Adidas Boost', price: 90),
      ItemModel(imageUrl: 'assets/images/img4.jpeg', itemName: 'Running shoes', price: 60),

      ];
      @override
      Widget build(BuildContext context) {
        return MaterialApp(

            home: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  //backgroundColor: Colors.transparent,
                  // backgroundColor: Colors.cyan,

                  title: const Center(
                    child: Text(
                      'shopIn',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
            body:ListView.builder(
          itemCount: items.length,
            itemBuilder: (context,index){
          return AllItemsCard(items: items[index]);
        })));
      }
    }
