// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String sentence;

  const VideoScreen({super.key, required this.sentence});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  VideoPlayerController? _videoController;
  String? videoUrl;
  bool isLoading = true;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    fetchVideo();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // Fetch video URL from Supabase
  Future<void> fetchVideo() async {
    try {
      final response = await supabase
          .from('Dict_data')
          .select('video_url')
          .eq('sentence', widget.sentence)
          .single();

      if (response['video_url'] != null) {
        setState(() {
          videoUrl = response['video_url'];
          _videoController = VideoPlayerController.network(videoUrl!)
            ..initialize().then((_) {
              setState(() {
                isLoading = false;
              });
            }).catchError((error) {
              print('Error initializing video: $error');
              setState(() => isLoading = false);
            });
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (error) {
      print('Error fetching video: $error');
      setState(() => isLoading = false);
    }
  }

  // Toggle play/pause
  void togglePlayPause() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      setState(() {
        isPlaying = !isPlaying;
        isPlaying ? _videoController!.play() : _videoController!.pause();
      });
    }
  }

  // Restart the video
  void restartVideo() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.seekTo(Duration.zero);
      _videoController!.play();
      setState(() => isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.1,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF67B5D1), Color(0xFFB0DFCC)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Back Button & Centered Title
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 32),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.sentence,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.25),

                // Video Display Container
                Center(
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenWidth * 0.8, // Square container
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : videoUrl != null &&
                                _videoController != null &&
                                _videoController!.value.isInitialized
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: screenWidth * 0.8,
                                    maxHeight: screenWidth * 0.8,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio:
                                        _videoController!.value.aspectRatio,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Video not available",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Play/Pause and Refresh Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIconButton(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      togglePlayPause,
                    ),
                    SizedBox(width: screenWidth * 0.1),
                    _buildIconButton(Icons.refresh, restartVideo),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom Icon Button
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }
}
