import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(left: 15,top: 5,bottom: 5),
      height: 200,
      width: 110,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: 130,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Icon(
              Icons.person,
              size: 100,
            ),
          ),
          Center(
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Center(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
class StoryCard2 extends StatelessWidget {
  const StoryCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 110,
      margin: EdgeInsets.only(left: 15, top: 5,bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),


      ),
      child:  Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
              image: AssetImage('assets/images/img1.jpg'),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: 15,

                  child: Icon(Icons.person,),
                ),
              ),
              Spacer(flex: 1,),
              Container(
                  margin: EdgeInsets.all(5),
                  child: Text('the name of the user',style: TextStyle(color: Colors.white,fontSize: 12),)),
            ],
          ),

        ],
      ),
    );
  }
}

