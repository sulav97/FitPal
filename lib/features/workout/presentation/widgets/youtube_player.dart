import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SimpleYoutubePlayer extends StatefulWidget {
  final String youtubeUrl;
  final String description;

  const SimpleYoutubePlayer({
    super.key,
    required this.youtubeUrl,
    required this.description,
  });

  @override
  _SimpleYoutubePlayerState createState() => _SimpleYoutubePlayerState();
}

class _SimpleYoutubePlayerState extends State<SimpleYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'Workout Detail',
          style: TextStyle(color: Colors.white60),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white60,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            YoutubePlayer(
              aspectRatio: 10 / 16,
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(widget.description, style: const TextStyle(color: Colors.white60)),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
