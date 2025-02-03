import 'package:ecommerceapp/models/item_model.dart';
import 'package:flutter/material.dart';

class AllItemsCard extends StatelessWidget {
  const AllItemsCard({super.key, required this.items});

  final ItemModel items;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      items.imageUrl,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.favorite_border),
                  ),
                ],
              ),
              Text(items.itemName),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3),
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '7 colors',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Row(
                children: [
                  Text('\$${items.price.toString()}',),
                  const Spacer(
                    flex: 1,
                  ),
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.add)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
