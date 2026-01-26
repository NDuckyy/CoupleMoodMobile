import 'dart:io';
import 'package:couple_mood_mobile/models/mood_face.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// import '../providers/auth_provider.dart';
// import '../services/emotion_service.dart';

class EmotionCameraScreen extends StatefulWidget {
  const EmotionCameraScreen({super.key});

  @override
  State<EmotionCameraScreen> createState() => _EmotionCameraScreenState();
}

class _EmotionCameraScreenState extends State<EmotionCameraScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _image;
  MoodFace? _result;
  bool _loading = false;

  Future<void> _takePhotoAndAnalyze() async {
    final mood = context.read<MoodProvider>();

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
      _loading = true;
      _result = null;
    });

    try {
      await mood.getCurrentMoodByCamera(imageFile);

      if (!mounted) return;

      setState(() {
        _result = mood.currentMood;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Phân tích thất bại: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quay lại')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          (_result != null && _result!.dominantEmotion.isNotEmpty)
          ? Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.goNamed("listLocation");
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Color(0xFF8CA9FF),
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
              if (_result == null && !_loading)
                const Column(
                  children: [
                    Image(
                      image: AssetImage('lib/assets/images/camera_icon.png'),
                      width: 300,
                      height: 300,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nhấn nút "Chụp & phân tích" để chụp ảnh khuôn mặt và phân tích cảm xúc của bạn.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

              if (_loading) ...[
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ],
              const SizedBox(height: 16),

              if (_image != null) ...[
                const SizedBox(height: 16),
                if (_result != null) ...[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            (_result != null &&
                                _result!.dominantEmotion.isNotEmpty)
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        _image!,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ],

              if (_result != null) ...[
                const SizedBox(height: 16),
                if (_result!.dominantEmotion.isEmpty) ...[
                  const Text(
                    'Không thể phân tích cảm xúc từ ảnh đã chụp.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ] else ...[
                  Column(
                    children: [
                      Text(
                        'Cảm xúc của bạn là: '
                        '${_result!.dominantEmotion}\n',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _result!.emotionSentence,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _takePhotoAndAnalyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8CA9FF),
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
            ],
          ),
        ),
      ),
    );
  }
}
