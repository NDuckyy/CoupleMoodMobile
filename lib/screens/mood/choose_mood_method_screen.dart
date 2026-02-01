import 'package:couple_mood_mobile/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseMoodMethodScreen extends StatefulWidget {
  const ChooseMoodMethodScreen({super.key});

  @override
  State<ChooseMoodMethodScreen> createState() => _ChooseMoodMethodScreenState();
}

class _ChooseMoodMethodScreenState extends State<ChooseMoodMethodScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('canPop = ${Navigator.of(context).canPop()}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quay lại'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PHƯƠNG THỨC CHỌN MOOD:',
              style: GoogleFonts.balooChettan2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8CA9FF),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bạn có thể chọn mood của mình bằng cách sử dụng biểu tượng cảm xúc hoặc chụp ảnh khuôn mặt',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                width: 300,
                alignment: Alignment.center,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Color(0xFF8CA9FF).withOpacity(0.7),
                ),
                child: TextButton(
                  onPressed: () {
                    context.pushNamed("moodChooseByIcon");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.face, size: 40, color: Colors.black),
                        SizedBox(width: 7),
                        Text(
                          'Chọn mood bằng biểu tượng',
                          style: GoogleFonts.balooChettan2(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 300,
                alignment: Alignment.center,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Color(0xFF8CA9FF).withOpacity(0.7),
                ),
                child: TextButton(
                  onPressed: () {
                    context.pushNamed("emotionCamera");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                            'lib/assets/images/camera_icon.png',
                          ),
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Chọn mood bằng khuôn mặt',
                          style: GoogleFonts.balooChettan2(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
