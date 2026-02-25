import 'package:couple_mood_mobile/widgets/time_panel_card.dart';
import 'package:flutter/material.dart';

class AvailableTimeSection extends StatelessWidget {
  final List<String> sang;
  final List<String> toi;
  final List<String> cuoiTuan;

  const AvailableTimeSection({
    super.key,
    required this.sang,
    required this.toi,
    required this.cuoiTuan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimePanelCard(
          icon: Icons.wb_sunny_rounded,
          title: "Buổi sáng",
          times: sang,
          gradientColors: const [
            Color(0xFFFDC5F5),
            Color(0xFFF7AEF8),
          ],
        ),
        const SizedBox(height: 16),
        TimePanelCard(
          icon: Icons.nightlight_round,
          title: "Buổi tối",
          times: toi,
          gradientColors: const [
            Color(0xFF8093F1),
            Color(0xFFB388EB),
          ],
        ),
        const SizedBox(height: 16),
        TimePanelCard(
          icon: Icons.celebration_rounded,
          title: "Cuối tuần",
          times: cuoiTuan,
          gradientColors: const [
            Color(0xFFB388EB),
            Color(0xFF72DDF7),
          ],
        ),
      ],
    );
  }
}