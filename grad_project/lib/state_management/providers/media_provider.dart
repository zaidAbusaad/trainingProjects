import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart'; // Import video player package

import '../../firebase_functions/media_handler.dart';

class MediaProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  File? selectedVideo;
  VideoPlayerController? _videoController; // Added video controller
  final MediaHandler _mediaHandler = MediaHandler();

  // Method to pick video
  Future<void> pickVideo(ImageSource source) async {
    final XFile? video = await _picker.pickVideo(source: source);
    if (video != null) {
      selectedVideo = File(video.path);
      _initializeVideoController(selectedVideo!);
      notifyListeners();
    }
  }
  void removeImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }

  // Method to remove the video from the selectedVideo variable
  void removeVideo() {
    _videoController?.dispose(); // Clean up the video controller
    _videoController = null;
    selectedVideo=null;
    notifyListeners();
  }
  // Method to initialize the video controller
  void _initializeVideoController(File videoFile) {
    _videoController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        notifyListeners(); // Notify listeners when video is ready
      }).catchError((error) {
        print("Error initializing video controller: $error");
      });
  }

  // Dispose the controller when it's no longer needed
  void disposeController() {
    _videoController?.dispose();
    _videoController = null;
    notifyListeners();
  }

  // Method to pick multiple images from the gallery
  Future<void> pickMultipleImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      selectedImages = images.map((image) => File(image.path)).toList();
      notifyListeners();
    }
  }

  // Method to capture multiple images
  Future<void> captureMultipleImages(BuildContext context) async {
    final List<File> images = await _mediaHandler.captureMultipleImages(() async {
      return await _showCaptureAnotherDialog(context);
    });
    if (images.isNotEmpty) {
      selectedImages = images;
      notifyListeners();
    }
  }

  // Show dialog to choose the video source (Gallery or Camera)
  void showVideoSourceDialog(BuildContext context) {
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
              pickVideo(ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              pickVideo(ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
        ],
      ),
    );
  }

  // Helper method to display a dialog for capturing another image
  Future<bool> _showCaptureAnotherDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Capture Another?'),
        content: const Text('Do you want to capture another image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  // Getter to check if there's any media
  bool get hasMedia => selectedImages.isNotEmpty || selectedVideo != null;

  // Clear all selected media
  void clearMedia() {
    selectedImages.clear();
    selectedVideo = null;
    disposeController(); // Dispose video controller when media is cleared
    notifyListeners();
  }

  // Getter to access the video controller (nullable)
  VideoPlayerController? get videoController => _videoController;
}
