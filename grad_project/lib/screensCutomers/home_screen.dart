import 'package:flutter/material.dart';
import 'package:grad_project/components/cutom_shapes/curved_edges.dart';
import 'package:grad_project/components/service_grid.dart';

import '../components/cutom_shapes/circular_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              height: screenHeight * .4,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: SizedBox(
                height: screenHeight * .3,
                child: Stack(
                  children: [
                    Positioned(
                      top: -150,
                      right: -250,
                      child: CircularContainer(
                        bgColor: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      right: -300,
                      child: CircularContainer(
                        bgColor: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    const Positioned(
                      top: 50,
                      left: 30,
                      child: Text(
                        'Handy.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    Positioned.fill(
                      top: 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), // Soft shadow
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20), // Smooth corners
                          ),
                          padding: EdgeInsets.all(10), // Adds spacing around image
                          child: Image.asset(
                            'lib/components/images/iii.jpeg', // Make sure the path is correct!
                            width: 200, // Increased size
                            height: 160, // Increased size
                            fit: BoxFit.cover, // Better scaling
                          ),
                        ),
                      ),
                    ),

                    // Positioned(
                    //   top: 50,
                    //   left: 130,
                    //   right: 20,
                    //   child: Container(
                    //     width: screenWidth*0.5,
                    //     padding: const EdgeInsets.symmetric(horizontal: 15),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(30),
                    //       boxShadow: const [
                    //         BoxShadow(
                    //           color: Colors.black12,
                    //           blurRadius: 10,
                    //         ),
                    //       ],
                    //     ),
                    //     child: const TextField(
                    //       decoration: InputDecoration(
                    //         hintText: 'Search...',
                    //         border: InputBorder.none,
                    //         icon: Icon(Icons.search),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          const ServiceGrid(
            isCustomer: true,
          ),
        ],
      ),
    );
  }
}
