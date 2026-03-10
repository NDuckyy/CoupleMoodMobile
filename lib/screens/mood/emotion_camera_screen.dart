import 'dart:io';

import 'package:couple_mood_mobile/models/mood/mood_face.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EmotionCameraScreen extends StatefulWidget {
  const EmotionCameraScreen({super.key});

  @override
  State<EmotionCameraScreen> createState() => _EmotionCameraScreenState();
}

class _EmotionCameraScreenState extends State<EmotionCameraScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _image;
  MoodFace? _result;

  Future<void> _takePhotoAndAnalyze() async {
    final moodProvider = context.read<MoodProvider>();

    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (picked == null) return;

    final imageFile = File(picked.path);

    setState(() {
      _image = imageFile;
      _result = null;
    });

    await moodProvider.getCurrentMoodByCamera(imageFile);

    if (!mounted) return;

    if (moodProvider.error == null) {
      setState(() {
        _result = moodProvider.currentMoodCamera;
      });
    } else {
      setState(() {
        _result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();

    final hasSuccess =
        _result != null && _result!.dominantEmotion.isNotEmpty;
    final hasError =
        moodProvider.error != null && !moodProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân tích cảm xúc'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: hasSuccess
          ? Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.goNamed('listLocation');
                },
                backgroundColor: const Color(0xFF8CA9FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : null,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              if (_image == null && !moodProvider.isLoading)
                const Column(
                  children: [
                    Image(
                      image: AssetImage(
                          'lib/assets/images/camera_icon.png'),
                      width: 300,
                      height: 300,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nhấn nút "Chụp & phân tích" để chụp ảnh khuôn mặt\nvà phân tích cảm xúc của bạn.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

              if (moodProvider.isLoading) ...[
                const SizedBox(height: 24),
                const SizedBox(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ],

              if (_image != null && !moodProvider.isLoading) ...[
                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: hasSuccess
                          ? Colors.greenAccent
                          : hasError
                              ? Colors.redAccent
                              : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      _image!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                if (hasError) ...[
                  Text(
                    moodProvider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],

                if (hasSuccess) ...[
                  Text(
                    'Cảm xúc của bạn là:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _result!.dominantEmotion,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _result!.emotionSentence,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ], 
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed:
                    moodProvider.isLoading ? null : _takePhotoAndAnalyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8CA9FF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Chụp & phân tích',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
