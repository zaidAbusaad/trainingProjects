import 'package:flutter/material.dart';
import 'package:projects/components/item.dart';

import '../models/number.dart';

class NumbersPage extends StatelessWidget {
   NumbersPage({super.key});

  final List<ItemModel> numbers = const [
    ItemModel(
        image: 'assets/images/numbers/number_one.png',
        jpName: 'eins',
        enName: 'one',
    audio: 'audio/numbers/number_eight_sound.mp3'),
    ItemModel(
        image: 'assets/images/numbers/number_two.png',
        jpName: 'zwei',
        enName: 'two',
    audio: 'audio/numbers/number_five_sound.mp3'),
    // Number(
    //     image: 'assets/images/numbers/number_three.png',
    //     jpName: 'Drei',
    //     enName: 'three'),
    // Number(
    //     image: 'assets/images/numbers/number_four.png',
    //     jpName: 'vier',
    //     enName: 'Four'),
    // Number(
    //     image: 'assets/images/numbers/number_five.png',
    //     jpName: 'funf',
    //     enName: 'five'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          'Numbers',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: numbers.length,
        itemBuilder: (context, index)
        {
          return Item(item: numbers[index],color: Colors.orange,);

        },

      ),
    );
  }
}
// List<Widget> getList (List<Number> numbers)
// {
//   List<Item> itemsList=[];
//   for(int i=0;i<numbers.length;i++){
//     itemsList.add(numbers[index];);
//   }
//   return itemsList;
// }


