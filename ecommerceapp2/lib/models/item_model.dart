class ItemModel{
 final String imageUrl;
 final  String itemName;
 final double price;
  int qty;
  bool isFavorite;

  ItemModel({required this.imageUrl,required this.itemName,required this.price,this.qty = 0,this.isFavorite = false});
}

