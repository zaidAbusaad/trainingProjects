
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/number.dart';
import 'item_info.dart';

class Item extends StatelessWidget {
  const Item({super.key, required this.item, required this.color});

  final Color color;

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: color,
      child: Row(
       children: [
         Container(color: Colors.white, child: Image.asset(item.image!)),
         Expanded(child: ItemInfo(item: item))
       ],
      ),
    );
  }
}


class PhrasesItem extends StatelessWidget {
  const PhrasesItem({super.key, required this.item, required this.color});

  final ItemModel item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: color,
      child: ItemInfo(item: item,),

    );
  }
}
