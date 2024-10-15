import 'package:ecommerceapp/components/categories_list.dart';
import 'package:ecommerceapp/components/item_list.dart';
import 'package:ecommerceapp/components/top_items_list.dart';
import 'package:ecommerceapp/screens/all_items_screen.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopItemsList(),
        const CategoriesList(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Container(
            height: 370.6,
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          'New Arrivals',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Container(
                          height: 40,
                          width: 85,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  AllItemsScreen()),
                              );
                            },
                            backgroundColor: Colors.purple,
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                 ItemList(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
