import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.all(10.0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              children: [
                FloatingActionButton(
                    onPressed: () {}, child: Icon(Icons.category)),
                Text('Category')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.compare),
                ),
                Text('Compare')
              ],
            ),),

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {},backgroundColor: Color(0xFFF3CFE8),
                  child: Icon(Icons.discount_outlined),
                ),
                Text('Sales event')
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8),
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {},backgroundColor: Color(0XFFFED18C),
                  child: Icon(Icons.attach_money,color: Colors.deepOrange,),
                ),

                Text('Offers')
              ],
            ),
          ),


        ],
      ),
    );
  }
}
