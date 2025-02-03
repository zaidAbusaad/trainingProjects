import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/models/item_model.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
  final CollectionReference productCollection = FirebaseFirestore.instance.collection('Products');

  // Method for updating user data
  Future<void> updateUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  // Method for adding product to the cart (handling quantity update or adding new)
  Future<void> addProductToCart(String userId, ItemModel item) async {
    try {
      // Check if the item already exists in the user's cart
      var cartItemQuery = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Cart')
          .where('itemName', isEqualTo: item.itemName)
          .get();

      if (cartItemQuery.docs.isNotEmpty) {
        // Item already exists in the cart, so we just update the quantity
        DocumentReference docRef = cartItemQuery.docs.first.reference;
        await docRef.update({
          'qty': FieldValue.increment(item.qty), // Increment the existing quantity
        });
      } else {
        // Item does not exist in the cart, so we add it
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Cart')
            .add({
          'imageUrl': item.imageUrl,
          'itemName': item.itemName,
          'price': item.price,
          'qty': item.qty,
        });
      }
    } catch (e) {
      print("Error adding product to cart: $e"); // Log any errors
    }
  }

  // Method for updating the quantity of the product in the cart (increment or decrement)
  Future<void> updateProductQuantity(String userId, ItemModel item, int quantityChange) async {
    try {
      // Check if the item already exists in the user's cart
      var cartItemQuery = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Cart')
          .where('itemName', isEqualTo: item.itemName)
          .get();

      if (cartItemQuery.docs.isNotEmpty) {
        // Item exists in cart, so update the quantity
        DocumentReference docRef = cartItemQuery.docs.first.reference;
        await docRef.update({
          'qty': FieldValue.increment(quantityChange), // Increment or decrement the quantity
        });
      } else {
        // Item does not exist in the cart, so add it
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Cart')
            .add({
          'imageUrl': item.imageUrl,
          'itemName': item.itemName,
          'price': item.price,
          'qty': item.qty,
        });
      }
    } catch (e) {
      print("Error updating product quantity in cart: $e");
    }
  }
  // Stream to get all products
  Stream<List<ItemModel>> get Products {
    return FirebaseFirestore.instance.collection('Products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemModel(
          imageUrl: doc['imageUrl'],
          itemName: doc['itemName'],
          price: doc['price'],
          qty: doc['qty'] ?? 0,
          isFavorite: doc['isFavorite'] ?? false,
        );
      }).toList();
    });
  }

  // Stream to get user's cart data
  Stream<List<ItemModel>> getUserCart(String userId) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Cart')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemModel(
          imageUrl: doc['imageUrl'],
          itemName: doc['itemName'],
          price: doc['price'],
          qty: doc['qty'],
        );
      }).toList();
    });
  }

  // Method for removing product from cart
  Future<void> removeProductFromCart(String userId, ItemModel item) async {
    try {
      // Find the document of the product in the cart and delete it by its ID
      var cartItemQuery = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Cart')
          .where('itemName', isEqualTo: item.itemName)
          .get();

      if (cartItemQuery.docs.isNotEmpty) {
        DocumentReference docRef = cartItemQuery.docs.first.reference;
        await docRef.delete(); // Delete the item from cart
      }
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }
}
