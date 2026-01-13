import 'package:flutter/material.dart';

class ChooseMoodScreen extends StatefulWidget {
  const ChooseMoodScreen({super.key});

  @override
  State<ChooseMoodScreen> createState() => _ChooseMoodScreenState();
}

class _ChooseMoodScreenState extends State<ChooseMoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Mood')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hãy chọn mood của bạn'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle Happy mood selection
                  },
                  child: Image.asset(
                    'lib/assets/images/nam_vui.png',
                    width: 70,
                    height: 70,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle Sad mood selection
                  },
                  child: Image.asset(
                    'lib/assets/images/nam_binh_tinh.png',
                    width: 70,
                    height: 70,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle Sad mood selection
                  },
                  child: Image.asset(
                    'lib/assets/images/nam_ngac_nhien.png',
                    width: 70,
                    height: 70,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle Angry mood selection
                  },
                  child: Image.asset(
                    'lib/assets/images/nam_boi_roi.png',
                    width: 70,
                    height: 70,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle Love mood selection
                  },
                  child: Image.asset(
                    'lib/assets/images/nam_buon.png',
                    width: 70,
                    height: 70,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle Sad mood selection
                  },
                  child: Image.asset(
                    'lib/assets/images/nam_kinh_tom.png',
                    width: 70,
                    height: 70,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle Calm mood selection
                  },
                  child: Image.asset(
                    'lib/assets/images/nam_so_hai.png',
                    width: 70,
                    height: 70,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle Excited mood selection
                  },
                  child: Image.asset(
                    'lib/assets/images/nam_gian_du.png',
                    width: 70,
                    height: 70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
