import 'dart:io';

import 'package:couple_mood_mobile/models/mood/mood_face.dart';
import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:couple_mood_mobile/screens/mood/widgets/camera_content.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
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

  bool _isConsentChecked = false;

  Future<void> _takePhotoAndAnalyze() async {
    if (!_isConsentChecked) {
      showMsg(context, 'Vui lòng đồng ý trước khi tiếp tục', false);
      return;
    }

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

      showMsg(context, 'Không thể phân tích cảm xúc, thử lại nhé', false);
    }
  }

  void _goToListLocation() {
    final moodProvider = context.read<MoodProvider>();

    if (_result != null && _result!.dominantEmotion.isNotEmpty) {
      moodProvider.getCurrentMood();
    }

    context.goNamed('listLocation');
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();

    final hasSuccess = _result != null && _result!.dominantEmotion.isNotEmpty;
    final hasError = moodProvider.error != null && !moodProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân tích cảm xúc'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFDFDFD),
      ),
      backgroundColor: const Color(0xFFF7F0FF),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Text(
              'Khám phá cảm xúc của bạn',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8093F1),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Chụp ảnh khuôn mặt để AI phân tích mood hiện tại 💜',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 280,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF7AEF8), Color(0xFFB388EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: CameraContent(
                      moodProvider: moodProvider,
                      hasSuccess: hasSuccess,
                      hasError: hasError,
                      imageFile: _image,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            //checkbox ok xài AI á
            CheckboxListTile(
              value: _isConsentChecked,
              onChanged: (value) {
                setState(() {
                  _isConsentChecked = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF8093F1),

              contentPadding: EdgeInsets.zero, // bỏ padding ngoài
              dense: true, // giảm chiều cao
              visualDensity: const VisualDensity(
                horizontal: -4, // kéo sát checkbox
                vertical: -4,
              ),

              title: Text(
                'Tôi đồng ý cung cấp hình ảnh khuôn mặt để hệ thống AI phân tích cảm xúc hiện tại.',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ),

            const SizedBox(height: 12),

            ///  BUTTON (bị disable nếu chưa tick)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (moodProvider.isLoading || !_isConsentChecked)
                    ? null
                    : _takePhotoAndAnalyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8093F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: moodProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Chụp & phân tích',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            if (hasSuccess)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _goToListLocation,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF8093F1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8093F1),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
