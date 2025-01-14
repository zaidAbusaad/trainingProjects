import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class SingleRequestScreen extends StatefulWidget {
  final String requestId;

  const SingleRequestScreen({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  _SingleRequestScreenState createState() => _SingleRequestScreenState();
}

class _SingleRequestScreenState extends State<SingleRequestScreen> {
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Requests')
            .doc(widget.requestId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Request not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final images = List<String>.from(data['images'] ?? []);
          final videoUrl = data['video'];
          final location = data['location'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (images.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(
                            images[index],
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  data['title'] ?? 'No Title',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  data['description'] ?? 'No Description',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                if (location != null)
                  Text(
                    'Location: (${location['latitude']}, ${location['longitude']})',
                    style: const TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 16),
                if (videoUrl != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Video:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 180,
                        child: GestureDetector(
                          onTap: () => _showFullScreenVideo(context),
                          child: FutureBuilder(
                            future: _initializeVideo(videoUrl),
                            builder: (context, videoSnapshot) {
                              if (videoSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (videoSnapshot.hasError) {
                                return const Center(
                                    child: Text('No video available.'));
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: VideoPlayer(_videoController!),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        onPressed: () {},
                        child: Text('Submit'),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _initializeVideo(String videoUrl) async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await _videoController!.initialize();
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
  void _showOfferDialog(BuildContext context){
    showDialog(context: context, builder: (context){
      TextEditingController _price = TextEditingController();
      TextEditingController _description = TextEditingController();

    return AlertDialog(
      title: Text('Submit Offer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

        ],
      ),
    );
    },
    );
  }
}
