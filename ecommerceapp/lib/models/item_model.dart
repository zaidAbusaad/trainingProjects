class ItemModel{
 final String imageUrl;
 final  String itemName;
 final double price;
  String? size;
  int qty;
  bool isFavorite;

  ItemModel({required this.imageUrl,required this.itemName,required this.price, this.size,this.qty = 0,this.isFavorite = false});
}

