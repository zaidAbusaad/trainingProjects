import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:projects/screens/numbers_page.dart';
import 'package:projects/screens/phrases_page.dart';
import 'package:projects/screens/tuneApp_page.dart';
import '../components/category_item.dart';
import 'package:projects/screens/familyMembers_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: const Text(
            'Toku',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Category(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NumbersPage();
                }));
              },
              text: 'Number',
              color: Colors.orange,
            ),
            Category(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return familyMembersPage();
                },),);
              },
              text: 'FamilyMembers',
              color: Colors.green,
            ),
            Category(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return familyMembersPage();
                },),);
              },
              text: 'colors',
              color: Colors.purple,
            ),
            Category(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhrasesPage();
                },),);
              },
              text: 'Phrases',
              color: Colors.lightBlueAccent,
            ),
            Category(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TuneApp();
                },),);
              },
              text: 'TuneApp',
              color: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
