import 'package:flutter/material.dart';
import 'package:newsproject/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});
final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        height: 100,
        width: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(category.imageUrl)),
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
            child: Text(
              category.categoryName,
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
