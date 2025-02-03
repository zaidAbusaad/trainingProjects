import 'package:flutter/material.dart';
import 'package:grad_project/components/cutom_shapes/curved_edges.dart';

import '../components/cutom_shapes/circular_container.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key, required this.child});
final Widget child;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          ClipPath(
            clipper: CurvedEdges(),
            child: Container(
              padding: const EdgeInsets.all(0),
              height: screenHeight*.4,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: SizedBox(
                height: screenHeight*.35,
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
                    child,



                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
