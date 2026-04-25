import 'dart:typed_data';

import 'package:couple_mood_mobile/utils/create_thumbnail.dart';
import 'package:couple_mood_mobile/widgets/chat/full_video_screen.dart';
import 'package:flutter/material.dart';

class VideoMessageItem extends StatefulWidget {
  final String videoUrl;

  const VideoMessageItem({super.key, required this.videoUrl});

  @override
  State<VideoMessageItem> createState() => _VideoMessageItemState();
}

class _VideoMessageItemState extends State<VideoMessageItem> {
  Future<Uint8List?>? _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    _thumbnailFuture = CreateThumbnail.generateThumbnail(widget.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullVideoScreen(videoUrl: widget.videoUrl),
          ),
        );
      },
      child: FutureBuilder<Uint8List?>(
        future: _thumbnailFuture,
        builder: (context, snapshot) {
          // 🔥 LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 200,
              height: 200,
              color: Colors.grey[900],
            );
          }

          // ❌ ERROR
          if (!snapshot.hasData || snapshot.data == null) {
            return Container(
              width: 200,
              height: 200,
              color: Colors.black,
              child: const Icon(Icons.videocam, color: Colors.white54),
            );
          }

          // ✅ SUCCESS
          return Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  snapshot.data!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const Icon(
                Icons.play_circle_fill,
                size: 60,
                color: Colors.white,
              ),
            ],
          );
        },
      ),
    );
  }
}