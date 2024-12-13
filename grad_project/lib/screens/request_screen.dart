import 'package:flutter/material.dart';
import 'package:grad_project/models/service_card_model.dart';

import '../components/cutom_shapes/circular_container.dart';
import '../components/cutom_shapes/curved_edges.dart';
import 'map_page.dart'; // Assuming you have a MapPage class in your project.

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key, required this.field});

 final ServiceCardModel field;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var fieldname= field.fieldName;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            ClipPath(
              clipper: CurvedEdges(),
              child: Container(
                padding: const EdgeInsets.all(0),
                height: screenHeight * .15,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: SizedBox(
                  height: screenHeight * .3,
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
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(
                                context); // Navigates back to the previous page
                          },
                        ),
                      ),
                      const Positioned(
                        top: 50,
                        left: 60,
                        child: Text(
                          'Handy.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Title and Subtitle
             Text(
              'In need of an $fieldname!',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              'Help us understand your problem..',
              style: TextStyle(fontSize: 18),
            ),
            const Divider(),

            // Request Title Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Add a title for your request',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Location Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'What’s your location...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Description Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Provide a detailed description of the problem',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Image or Video Upload
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add functionality for image upload
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Upload Image'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add functionality for video upload
                    },
                    icon: const Icon(Icons.videocam),
                    label: const Text('Upload Video'),
                  ),
                ],
              ),
            ),

            // Google Maps Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  );
                },
                icon: const Icon(Icons.map),
                label: const Text('Open Google Maps'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

