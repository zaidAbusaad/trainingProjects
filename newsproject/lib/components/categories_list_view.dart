import 'package:flutter/material.dart';

import '../models/category_model.dart';
import 'category_card.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});
final List<CategoryModel> categories=const
[
 CategoryModel(imageUrl: 'assets/images/business.avif', categoryName:'Business') ,
  CategoryModel(imageUrl: 'assets/images/entertaiment.avif', categoryName:'Entertainment') ,
  CategoryModel(imageUrl: 'assets/images/general.avif', categoryName:'General') ,
  CategoryModel(imageUrl: 'assets/images/health.avif', categoryName:'Health') ,
  CategoryModel(imageUrl: 'assets/images/science.avif', categoryName:'Science') ,
  CategoryModel(imageUrl: 'assets/images/sports.avif', categoryName:'Sports') ,
  CategoryModel(imageUrl: 'assets/images/technology.jpeg', categoryName:'Technology') ,
];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return  CategoryCard(category: categories[index],);
          }),
    );
  }
}

