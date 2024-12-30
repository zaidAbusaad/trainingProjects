import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaHandler {
  final ImagePicker _picker = ImagePicker();
  final List<File> images = [];
  // Pick multiple images from the gallery
  Future<List<File>> pickMultipleImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      return images.map((image) => File(image.path)).toList();
    }
    return [];
  }

  // Capture a single image from the camera
  Future<File?> pickSingleImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  // Pick a single video
  Future<File?> pickVideo(ImageSource source) async {
    final XFile? video = await _picker.pickVideo(source: source);
    if (video != null) {
      return File(video.path);
    }
    return null;
  }

  // Capture multiple images using the camera
  Future<List<File>> captureMultipleImages(Future<bool> Function() promptForNextCapture) async {
    bool continueCapturing = true;

    while (continueCapturing) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        images.add(File(image.path));
      }

      // Ask the user if they want to capture another image
      continueCapturing = await promptForNextCapture();
    }

    return images;
  }
}
