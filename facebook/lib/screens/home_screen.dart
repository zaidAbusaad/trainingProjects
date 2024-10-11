import 'package:facebook/components/story_card.dart';
import 'package:facebook/components/story_card_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
            Container(
              height: 50,
              width: 250,
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25)),
              child: Center(
                child: const TextField(
                  decoration: InputDecoration.collapsed(
                    hintText: 'What\'s on your mind?',
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.image_outlined,
                color: Colors.green,
              ),
            ),
          ],
        ),
        Divider(
          thickness: 3,
        ),
        StoryCardList(),
        Divider(
          thickness: 3,
        ),
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                  Text('the name of the user'),
                  Spacer(
                    flex: 1,
                  ),
                  Container(
                      padding: EdgeInsets.all(10), child: Icon(Icons.menu)),
                ],
              ),
              SizedBox(height: 45,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height:300 ,
                width: 300,
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/img2.jpeg'),
                ),
              ),
              SafeArea(

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton.icon(onPressed: (){},label:Text('Like'),icon: Icon(Icons.thumb_up_alt_outlined) ,style:TextButton.styleFrom(foregroundColor: Colors.grey) , ),
                    TextButton.icon(onPressed: (){},label:Text('Comment'),icon: Icon(Icons.mode_comment_outlined) ,style:TextButton.styleFrom(foregroundColor: Colors.grey) , ),
                    TextButton.icon(onPressed: (){},label:Text('Send'),icon: Icon(Icons.send) ,style:TextButton.styleFrom(foregroundColor: Colors.grey) , ),

                
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
