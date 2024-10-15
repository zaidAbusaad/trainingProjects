import 'package:ecommerceapp/components/size_grid_model.dart';
import 'package:ecommerceapp/list_cubit/product_cubit.dart';
import 'package:ecommerceapp/models/item_model.dart';
import 'package:flutter/material.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key, required this.item});
  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    ProductCubit cubit = ProductCubit.get(context);
    return Scaffold(
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
                        borderRadius: BorderRadius.circular(75),
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
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[50],
                    border: Border.all(
                      color: Colors.black,
                    )),
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '\$${item.price}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(75)),
                    child: const Icon(Icons.favorite_border),
                  ),
                  Container(
                    height: 35,
                    width: 35,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(75)),
                    child: const Icon(Icons.share),
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    item.itemName,
                    style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  )),
              SizeGrid(),

              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Text('Description')),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18,),

                child: const Text('they were made for consumers who may or may not love basketball (who may or may not even play sports) and from any walk of life.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12,color: Colors.grey),),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      height: 75,
                      width: 150,
                      child: FloatingActionButton(onPressed: (){


                        cubit.addItem(item);
                      },
                          child: const Text('Add To Cart')),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
