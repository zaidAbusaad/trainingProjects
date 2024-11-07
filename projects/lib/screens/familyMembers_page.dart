import 'package:flutter/material.dart';
import 'package:projects/components/item.dart';

import '../models/number.dart';

class familyMembersPage extends StatelessWidget {
  familyMembersPage({super.key});

  final List<ItemModel> numbers = const [
    ItemModel(
        image: 'assets/images/family_members/family_father.png',
        jpName: 'fater',
        enName: 'father',
    audio: 'audio/family_members/father.wav',),
    ItemModel(
        image: 'assets/images/family_members/family_mother.png',
        jpName: 'mutter',
        enName: 'mother',
      audio: 'audio/family_members/father.wav',),
    ItemModel(
        image: 'assets/images/family_members/family_son.png',
        jpName: 'Drei',
        enName: 'three',
      audio: 'audio/family_members/father.wav',),
    ItemModel(
        image: 'assets/images/numbers/number_four.png',
        jpName: 'vier',
        enName: 'Four',
      audio: 'assets/audio/family_members/father.wav',),

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          'Family Members',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: numbers.length,
        itemBuilder: (context, index)
        {
          return Item(item: numbers[index],color: Colors.green,);

        },

      ),
    );
  }
}
