import 'package:facebook/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:facebook/layout_cubit/layout_cubit.dart';


class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 6,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            // Reduces the width of the Row to its children
            children: [

              const Text(
                'facebook',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(
                flex: 1,
              ), // Space between text and first button
              Wrap(
                spacing: 0, // No space between the buttons
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.zero,
                      // No padding
                      minimumSize: Size(40, 40),
                      // Minimal size to keep the icon visible
                      backgroundColor: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.black,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.zero,
                      // No padding
                      minimumSize: Size(40, 40),
                      // Minimal size to keep the icon visible
                      backgroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.telegram,
                      size: 40,
                      color: Colors.black,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.zero,
                      // No padding
                      minimumSize: Size(40, 40),
                      // Minimal size to keep the icon visible
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon:Icon(Icons.home_filled,color: Colors.blue,),

              ),
              Tab(
                icon:Icon(Icons.video_call_outlined)
              ),
              Tab(
                icon:Icon(Icons.people_outline)
              ),
              Tab(
                icon:Icon(Icons.shopping_cart_outlined)
              ),
              Tab(
                icon:Icon(Icons.notifications_none_outlined)
              ),
              Tab(
                icon:Icon(Icons.menu)
              ),
            ],
          ),
        ),
        body: HomeScreen(),
      ),

    );
  }
}
