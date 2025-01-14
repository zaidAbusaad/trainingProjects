import '../models/item_model.dart';

abstract class ProductStates{}
class Initialproductstate extends ProductStates{}
class IncrementSuccess extends ProductStates{}
class DecrementSuccess extends ProductStates{}
class SuccessChangeIsFavorite extends ProductStates{}
class RemoveItemSuccess extends ProductStates{}
class ProductUpdated extends ProductStates {
  final List<ItemModel> updatedItems;

  ProductUpdated(this.updatedItems);
}