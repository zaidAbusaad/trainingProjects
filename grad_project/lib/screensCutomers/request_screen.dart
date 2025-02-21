import 'package:flutter/material.dart';
import 'package:grad_project/firebase_functions/media_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../components/cutom_shapes/circular_container.dart';
import '../components/cutom_shapes/curved_edges.dart';
import '../firebase_functions/request_service.dart';
import '../state_management/providers/media_provider.dart';
import '../models/service_card_model.dart';
import 'map_page.dart'; // Ensure you import MediaProvider

class RequestScreen extends StatelessWidget {
  RequestScreen({super.key, required this.field});

  final ServiceCardModel field;

  static final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Added GlobalKey
  final TextEditingController titleController =
      TextEditingController(); // Persistent controller
  final TextEditingController descriptionController =
      TextEditingController(); // Persistent controller

  @override
  Widget build(BuildContext context) {
    var mediaProvider = Provider.of<MediaProvider>(context);

    // Get the video controller from MediaProvider
    VideoPlayerController? videoController = mediaProvider.videoController;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(context),
              _buildTitleSection(),
              _buildTextField(titleController, "Add a title for your request"),
              _buildTextField(descriptionController,
                  "Provide a detailed description of the problem",
                  maxLines: 4),
              _buildMediaButtons(context, mediaProvider),
              _buildMapButton(context),
              _buildMediaPreview(mediaProvider),
              // Video Preview Section
              if (videoController != null &&
                  videoController.value.isInitialized)
                _buildVideoPreview(mediaProvider),
              _buildSubmitButton(context, mediaProvider, titleController,
                  descriptionController, field),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ClipPath(
      clipper: CurvedEdges(),
      child: Container(
        height: 150,
        decoration: const BoxDecoration(color: Colors.blue),
        child: Stack(
          children: [
            const Positioned(
                top: -150, right: -250, child: CircularContainer()),
            const Positioned(top: 100, right: -300, child: CircularContainer()),
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                            'are you sure you want to discard this request'),
                        actions: [
                          ElevatedButton(
                            onPressed: Navigator.of(ctx).pop,
                            child: Text('No'),
                          ),
                          ElevatedButton(
                            onPressed:(){
                              Provider.of<MediaProvider>(context, listen: false).clearMedia();
                              Navigator.of(context).pop();
                              Navigator.of(ctx).pop();
                              },
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Positioned(
              top: 50,
              left: 60,
              child: const Text(
                'Handy.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'In need of an ${field.profession}!',
        style: const TextStyle(
            color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _buildMediaButtons(BuildContext context, MediaProvider mediaProvider) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: ElevatedButton.icon(
              onPressed: () => _showImageSourceDialog(context),
              icon: const Icon(Icons.image),
              label: const Text('Upload Images'),
            ),
          ),
          SizedBox(
            width: screenWidth*0.02,
          ),
          Flexible(
            child: ElevatedButton.icon(
              onPressed: () => _showVideoSourceDialog(context),
              icon: const Icon(Icons.videocam),
              label: const Text('Upload Video'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapPage())),
        icon: const Icon(Icons.map),
        label: const Text('Open Google Maps'),
      ),
    );
  }

  Widget _buildMediaPreview(MediaProvider mediaProvider) {
    return mediaProvider.hasMedia
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: mediaProvider.selectedImages.map((image) {
                    int imageIndex =
                        mediaProvider.selectedImages.indexOf(image);
                    return Stack(
                      children: [
                        Image.file(image, width: 100, height: 100),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              // Remove the image from the list
                              mediaProvider.removeImage(imageIndex);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget _buildVideoPreview(MediaProvider mediaProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white), color: Colors.black),
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: mediaProvider.videoController!.value.aspectRatio,
              child: VideoPlayer(mediaProvider.videoController!),
            ),
            Positioned(
              child: IconButton(
                icon: Icon(
                  mediaProvider.videoController!.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  mediaProvider.videoController!.value.isPlaying
                      ? mediaProvider.videoController!.pause()
                      : mediaProvider.videoController!.play();
                },
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  mediaProvider.removeVideo();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    MediaProvider mediaProvider,
    TextEditingController titleController,
    TextEditingController descriptionController,
    ServiceCardModel field,
  ) {
    return ElevatedButton(
      onPressed: () async {
        // Check if the location is selected
        if (globalLastTappedLocation == null) {
          // If location is not selected, show a snack bar or a dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Please select a location on the map.")),
          );
          return;
        }

        // Call the submitRequest method with the location
        await RequestService.submitRequest(
          context,
          mediaProvider,
          titleController,
          descriptionController,
          field,
        );
      },
      child: const Text('Submit'),
    );
  }

  // Dialog to choose image source
  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: const Text(
            'Do you want to pick from the gallery or take pictures using the camera?'),
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
            'Do you want to pick a video from the gallery or record using the camera?'),
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
