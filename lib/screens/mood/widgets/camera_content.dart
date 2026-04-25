import 'dart:io';

import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:flutter/material.dart';

class CameraContent extends StatefulWidget {
  final MoodProvider moodProvider;
  final bool hasSuccess;
  final bool hasError;
  final File? imageFile;

  const CameraContent({
    super.key,
    required this.moodProvider,
    required this.hasSuccess,
    required this.hasError,
    required this.imageFile,
  });

  @override
  State<CameraContent> createState() => _CameraContentState();
}

class _CameraContentState extends State<CameraContent> {
  @override
  Widget build(BuildContext context) {
    final hasImage = widget.imageFile != null;

    if (widget.moodProvider.isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text("Đang phân tích cảm xúc..."),
        ],
      );
    }

    if (widget.hasError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 10),
          Text(
            widget.moodProvider.error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    if (!hasImage) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(image: AssetImage('lib/assets/images/camera_icon.png'), width: 120, height: 120),
          SizedBox(height: 10),
          Text('Chưa có ảnh', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(
            widget.imageFile!,
            width: 220,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),

        if (widget.hasSuccess) ...[
          Text(
            widget.moodProvider.currentMoodCamera!.dominantEmotion,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8093F1),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.moodProvider.currentMoodCamera!.emotionSentence,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ],
    );
  }
}
