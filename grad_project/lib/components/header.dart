import 'package:flutter/material.dart';

import 'cutom_shapes/circular_container.dart';
import 'cutom_shapes/curved_edges.dart';

class Header extends StatelessWidget {
  const Header({ required this.title, required this.backBtn});
  final String title;
 final bool backBtn;
  @override
  Widget build(BuildContext context) {
    return  ClipPath(
      clipper: CurvedEdges(),
      child: Container(
        height: 150,
        decoration: const BoxDecoration(color: Colors.blue),
        child: Stack(
          children: [
            const Positioned(
              top: -150,
              right: -250,
              child: CircularContainer(),
            ),
            const Positioned(
              top: 100,
              right: -300,
              child: CircularContainer(),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: backBtn ?  IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ) : Container(),
            ),
            Positioned(
              top: 50,
              left: 60,
              child: Text(
                '$title ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
