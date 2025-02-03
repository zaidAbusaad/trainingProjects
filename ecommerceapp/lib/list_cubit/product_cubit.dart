import 'package:ecommerceapp/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/database.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductStates> {
  ProductCubit() : super(Initialproductstate());

  static ProductCubit get(context) => BlocProvider.of(context);

  final List<ItemModel> items = [
    ItemModel(
        imageUrl: 'assets/images/img3.jpeg',
        itemName: 'Puma Running ',
        price: 100),
    ItemModel(
        imageUrl: 'assets/images/img5.jpeg',
        itemName: 'Nike Running',
        price: 90),
    ItemModel(
        imageUrl: 'assets/images/img6.jpeg',
        itemName: 'tennis shoes',
        price: 40),
    ItemModel(
        imageUrl: 'assets/images/img1.jpeg',
        itemName: 'Nike Jordan 1\'s',
        price: 150),
    ItemModel(
        imageUrl: 'assets/images/img2.jpeg',
        itemName: 'Adidas Boost',
        price: 90),
    ItemModel(
        imageUrl: 'assets/images/img4.jpeg',
        itemName: 'Running shoes',
        price: 60),
  ];

  List<ItemModel> cartItems = [];


  void increment(ItemModel item) {
    item.qty++;
    emit(IncrementSuccess());
  }

  void decrement(ItemModel item) {
    if (item.qty > 1) {
      item.qty--;
    }
    emit(DecrementSuccess());
  }

  void removeItem(ItemModel item) {
    cartItems.remove(item);
    emit(ProductUpdated(cartItems));
  }

  void addItem(ItemModel item) {
    bool isFound = cartItems.any((element) => element.itemName == item.itemName);
    if (isFound) {
      increment(item);
    } else {
      item.qty = 1;
      cartItems.add(item);
    }
    emit(ProductUpdated(cartItems));
  }
  void changeIsFavorite(ItemModel item) {
    item.isFavorite = !item.isFavorite;
    emit(SuccessChangeIsFavorite());
  }
}







