import 'package:facebook/components/story_card.dart';
import 'package:flutter/material.dart';

class StoryCardList extends StatelessWidget {
  const StoryCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
          itemCount:10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            if(index==0){
              return StoryCard();
            }else{
              return StoryCard2();
            }
          }),
    );
  }
}
