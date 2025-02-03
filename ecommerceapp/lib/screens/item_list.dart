import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the list of items from the provider
    final List<ItemModel>? items = Provider.of<List<ItemModel>?>(context);

    // If items is null or empty, display a message
    if (items == null || items.isEmpty) {
      return const Center(child: Text('No items available.'));
    }

    // Return a ListView to display the items
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: Image.network(item.imageUrl.isNotEmpty ? item.imageUrl : 'default_image_url_here'), // Use a default image if necessary
          title: Text(item.itemName),
          subtitle: Text('\$${item.price.toString()}'),
        );
      },
    );
  }
}
