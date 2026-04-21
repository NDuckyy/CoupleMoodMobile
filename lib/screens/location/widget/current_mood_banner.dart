import 'package:couple_mood_mobile/providers/mood_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentMoodBanner extends StatelessWidget {
  const CurrentMoodBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();
    final displayMood = moodProvider.coupleMood ?? "Chưa xác định";

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8093F1), Color(0xFF72DDF7)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFB388EB).withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ICON
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 20),
            ),

            const SizedBox(width: 12),

            /// TEXT
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Tâm trạng cặp đôi hiện tại: ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (moodProvider.isLoading)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else
                      TextSpan(
                        text: displayMood,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
