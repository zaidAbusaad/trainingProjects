import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../firebase_functions/database_service.dart';
import '../models/media_provider.dart';
import '../models/request_model.dart';
import '../models/service_card_model.dart';
import '../components/cutom_shapes/circular_container.dart';
import '../components/cutom_shapes/curved_edges.dart';
import 'package:video_player/video_player.dart';
import 'map_page.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key, required this.field});

  final ServiceCardModel field;

  @override
  Widget build(BuildContext context) {
    var mediaProvider = Provider.of<MediaProvider>(context);
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    LatLng? selectedLocation; // Store selected location

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            ClipPath(
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
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 60,
                      child: const Text(
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
            // Title Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'In need of an ${field.fieldName}!',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Add a title for your request',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Description Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Provide a detailed description of the problem',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Image and Video Upload Buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showImageSourceDialog(context),
                    icon: const Icon(Icons.image),
                    label: const Text('Upload Images'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showVideoSourceDialog(context),
                    icon: const Icon(Icons.videocam),
                    label: const Text('Upload Video'),
                  ),
                ],
              ),
            ),
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
            const Divider(),
            // Display Selected Media
            if ((mediaProvider.selectedImages != null &&
                mediaProvider.selectedImages!.isNotEmpty) ||
                (mediaProvider.controller != null &&
                    mediaProvider.controller!.value.isInitialized))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    // Display Images
                    if (mediaProvider.selectedImages != null &&
                        mediaProvider.selectedImages!.isNotEmpty)
                      ...mediaProvider.selectedImages!
                          .map((image) =>
                          Image.file(image, width: 100, height: 100))
                          .toList(),
                    // Display Video
                    if (mediaProvider.controller != null &&
                        mediaProvider.controller!.value.isInitialized)
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: AspectRatio(
                          aspectRatio:
                          mediaProvider.controller!.value.aspectRatio,
                          child: VideoPlayer(mediaProvider.controller!),
                        ),
                      ),
                  ],
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                String? userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User not logged in")),
                  );
                  return;
                }
                // Use the new DatabaseService methods
                List<Map<String, dynamic>> mediaList = [];
                if (mediaProvider.selectedImages != null) {
                  mediaList.addAll(mediaProvider.selectedImages!
                      .map((file) => {"type": "image", "file": file, "priority": "1",}));
                }
                if (mediaProvider.selectedVideo != null) {
                  mediaList.add({
                    "type": "video",
                    "file": mediaProvider.selectedVideo!,
                    "priority": "2",
                  });
                }
                final dbService = DatabaseService(uid: userId);
                // Collect data from user inputs
                String title = titleController.text.trim();
                String description = descriptionController.text.trim();
                String uid = userId;
                // Validate inputs
                if (title.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Title and description cannot be empty")),
                  );
                  return;
                }

                // Collect location and media
                LatLng? selectedLocation = globalLastTappedLocation;
                if (selectedLocation == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a location")),
                  );
                  return;
                }
                List<String> imageUrls = [];
                String videoUrl = '';

                // Upload media and save request
                try {
                  // Upload images
                  if (mediaProvider.selectedImages != null) {
                    for (var image in mediaProvider.selectedImages!) {
                      String imageUrl = await dbService.uploadMediaToStorage(
                        image,
                          'Users/$userId/Images',
                      );
                      if (imageUrl.isNotEmpty) {
                        imageUrls.add(imageUrl);
                      }
                    }
                  }

                  // Upload video
                  if (mediaProvider.selectedVideo != null) {
                    videoUrl = await dbService.uploadMediaToStorage(
                      mediaProvider.selectedVideo!,
                      'Users/$userId/Videos',
                    );
                  }

                  // Save request data to Firestore
                  await dbService.saveRequestData(
                    title: title,
                    description: description,
                    location: selectedLocation!,
                    images: imageUrls,
                    video: videoUrl,
                    status: false
                  );

                  await dbService.saveRequestData_request(
                    title: title,
                    description: description,
                    location: selectedLocation!,
                    images: imageUrls,
                    video: videoUrl,
                    service: '',
                    userId: uid,
                    status: false,

                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Request submitted successfully!")),
                  );

                  Navigator.pop(context); // Return to the previous screen
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to upload: $e")),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to choose image source
  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: const Text(
          'Do you want to pick from the gallery or take pictures using the camera?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<MediaProvider>(context, listen: false)
                  .pickMultipleImages();
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<MediaProvider>(context, listen: false)
                  .captureMultipleImages(context);
            },
            child: const Text('Camera'),
          ),
        ],
      ),
    );
  }

  // Dialog to choose video source
  void _showVideoSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose Video Source'),
        content: const Text(
          'Do you want to pick a video from the gallery or record using the camera?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<MediaProvider>(context, listen: false)
                  .pickVideo(ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<MediaProvider>(context, listen: false)
                  .pickVideo(ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
        ],
      ),
    );
  }
}
