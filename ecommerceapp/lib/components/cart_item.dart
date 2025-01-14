import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../models/user.dart';
import '../services/database.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.items});
  final ItemModel items;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final userId = user?.uid;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 125,
            width: 120,
            child: Image.asset(items.imageUrl),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(items.itemName, style: Theme.of(context).textTheme.bodyLarge),
                  const Text('The size'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${items.price}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Total: \$${items.price * items.qty}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      _QuantityAdjuster(
                        item: items,
                        userId: userId,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityAdjuster extends StatelessWidget {
  const _QuantityAdjuster({
    required this.item,
    required this.userId,
  });

  final ItemModel item;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (userId != null) {
              if (item.qty > 1) {
                // Decrease quantity by 1 in Firebase
                DatabaseService(uid: userId).updateProductQuantity(userId!, item, -1);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.itemName} quantity decreased')),
                );
              } else {
                // Remove the item if qty is 1
                DatabaseService(uid: userId).removeProductFromCart(userId!, item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.itemName} removed from cart')),
                );
              }
            }
          },
          icon: Icon(item.qty == 1 ? Icons.delete_outline : Icons.remove),
        ),
        Text('${item.qty}', style: Theme.of(context).textTheme.bodyLarge),
        IconButton(
          onPressed: () {
            if (userId != null) {
              // Increase quantity by 1 in Firebase
              DatabaseService(uid: userId).updateProductQuantity(userId!, item, 1);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.itemName} quantity increased')),
              );
            }
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
