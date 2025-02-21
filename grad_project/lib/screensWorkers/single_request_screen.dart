import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../components/header.dart';
import '../screensCutomers/offers_screen_customers.dart';
import '../components/offer_dialog.dart';

class SingleRequestScreen extends StatefulWidget {
  final String requestId;
  final bool isWorker;

  const SingleRequestScreen({
    Key? key,
    required this.requestId,
    required this.isWorker,
  }) : super(key: key);

  @override
  _SingleRequestScreenState createState() => _SingleRequestScreenState();
}

class _SingleRequestScreenState extends State<SingleRequestScreen> {
  VideoPlayerController? _videoController;
  String? videoUrl;
  List<String> images = [];
  String? title, description;
  Map<String, dynamic>? location;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRequestData();
  }

  Future<void> _fetchRequestData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Requests')
          .doc(widget.requestId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        setState(() {
          title = data['title'] ?? 'No Title';
          description = data['description'] ?? 'No Description';
          images = List<String>.from(data['images'] ?? []);
          videoUrl = data['video'];
          location = data['location'];
          isLoading = false;

          if (videoUrl != null) {
            _initializeVideo(videoUrl!);
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching request data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : title == null
          ? const Center(child: Text('Request not found.'))
          : SingleChildScrollView(
        child: Column(
          children: [
            Header(title: 'Request Details', backBtn: true),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (images.isNotEmpty)
                    SizedBox(
                      height: screenHeight * 0.3,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                            const EdgeInsets.only(right: 8.0),
                            child: Image.network(
                              images[index],
                              width: screenWidth * 0.5,
                              height: screenHeight * 0.3,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    title!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  if (location != null)
                  GestureDetector(
                    onTap: () {
                      final latitude = location!['latitude'];
                      final longitude = location!['longitude'];
                      final googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
                      launchUrl(Uri.parse(googleMapsUrl)); // Open Google Maps
                    },
                    child: Text(
                      'View Location on Map',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Blue to indicate a clickable link
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  if (videoUrl != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Video:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        GestureDetector(
                          onTap: () => _showFullScreenVideo(context),
                          child: _buildVideoPreview(),
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        widget.isWorker
                            ? FloatingActionButton.extended(
                          onPressed: () {
                            showOfferDialog(
                                context: context,
                                requestId: widget.requestId);
                          },
                          icon: Icon(Icons.add,
                              color: Colors.white),
                          label: Text(
                            'Make Offer',
                            style:
                            TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.blue,
                          tooltip: 'Make an Offer',
                          elevation: 5.0,
                        )
                            : ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OffersScreenCustomers(
                                        requestId:
                                        widget.requestId,
                                      )),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: Size(double.infinity,
                                screenWidth * 0.125),
                          ),
                          child: Text(
                            'All Offers!',
                            style:
                            TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeVideo(String videoUrl) async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await _videoController!.initialize();
    setState(() {});
  }

  Widget _buildVideoPreview() {
    if (videoUrl == null || videoUrl!.isEmpty) {
      return _noVideoAvailableWidget();
    }

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_videoController!.value.hasError) {
      return _videoErrorWidget();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        ),
        Icon(
          Icons.play_circle_filled,
          color: Colors.white.withOpacity(0.9),
          size: 48,
        ),
      ],
    );
  }

  /// Widget for when no video is available
  Widget _noVideoAvailableWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videocam_off, color: Colors.grey[500], size: 40),
            SizedBox(height: 8),
            Text(
              'No Video Available',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget for when there is a video loading error
  Widget _videoErrorWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 40),
            SizedBox(height: 8),
            Text(
              'Error Loading Video',
              style: TextStyle(color: Colors.red[700], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenVideo(BuildContext context) {
    if (_videoController == null || !_videoController!.value.isInitialized)
      return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              setState(() {
                _videoController!.value.isPlaying
                    ? _videoController!.pause()
                    : _videoController!.play();
              });
            },
            child: Icon(
              _videoController!.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
