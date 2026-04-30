import 'package:couple_mood_mobile/screens/mood/widgets/mood_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseMoodMethodScreen extends StatefulWidget {
  const ChooseMoodMethodScreen({super.key});

  @override
  State<ChooseMoodMethodScreen> createState() => _ChooseMoodMethodScreenState();
}

class _ChooseMoodMethodScreenState extends State<ChooseMoodMethodScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDC5F5).withOpacity(0.25), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFB388EB).withOpacity(0.15),
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: 60,
                    color: Color(0xFFB388EB),
                  ),
                ),

                const SizedBox(height: 30),

                /// 📝 TITLE
                Text(
                  'Bạn muốn chọn tâm trạng như thế nào?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.balooChettan2(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB388EB),
                  ),
                ),

                const SizedBox(height: 12),

                /// 📄 DESCRIPTION
                Text(
                  'Hôm nay bạn cảm thấy thế nào?\nHãy thể hiện bằng biểu tượng hoặc khuôn mặt của bạn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 40),

                /// 🔘 BUTTON 1
                MoodButton(
                  text: 'Chọn bằng biểu tượng',
                  icon: Icon(
                    Icons.emoji_emotions,
                    size: 30,
                    color: Colors.white,
                  ),
                  onTap: () => context.pushNamed("moodChooseByIcon"),
                ),

                const SizedBox(height: 16),

                /// 🔘 BUTTON 2
                MoodButton(
                  text: 'Chọn bằng khuôn mặt',
                  icon: Image.asset(
                    'lib/assets/images/camera_icon.png',
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                  onTap: () => context.pushNamed("emotionCamera"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
