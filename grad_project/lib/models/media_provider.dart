import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/media_handler.dart';

import 'package:video_player/video_player.dart';

class MediaProvider with ChangeNotifier {
  final MediaHandler _mediaHandler = MediaHandler();

  List<File>? _selectedImages = [];
  File? _selectedVideo;
  VideoPlayerController? _controller;

  List<File>? get selectedImages => _selectedImages;
  File? get selectedVideo => _selectedVideo;
  VideoPlayerController? get controller => _controller;

  // Pick multiple images from the gallery
  Future<void> pickMultipleImages() async {
    final List<File> images = await _mediaHandler.pickMultipleImages();
    if (images.isNotEmpty) {
      _selectedImages = images;
      notifyListeners();
    }
  }

  // Capture multiple images using the camera
  Future<void> captureMultipleImages(BuildContext context) async {
    final List<File> images = await _mediaHandler.captureMultipleImages(() async {
      return await _showCaptureAnotherDialog(context);
    });
    if (images.isNotEmpty) {
      _selectedImages = images;
      notifyListeners();
    }
  }

  // Pick a single video
  Future<void> pickVideo(ImageSource source) async {
    final File? video = await _mediaHandler.pickVideo(source);
    if (video != null) {
      _selectedVideo = video;
      _controller = VideoPlayerController.file(video)
        ..initialize().then((_) {
          notifyListeners();
          _controller!.play();
        });
    }
  }

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
    ) ??
        false;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
