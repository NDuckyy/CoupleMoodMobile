import 'package:couple_mood_mobile/providers/test_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalityCard extends StatefulWidget {
  const PersonalityCard({super.key});

  @override
  State<PersonalityCard> createState() => PersonalityCardState();
}

class PersonalityCardState extends State<PersonalityCard> {

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TestProvider>();
    debugPrint("Personality type: ${provider.personalityType}, loading: ${provider.myPersonalityTypeLoading}");
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFB388EB), Color(0xFFFDC5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: provider.myPersonalityTypeLoading
          ? const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : Row(
              children: [
                /// ICON
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 14),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tính cách của bạn",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        provider.personalityType ?? "Chưa có dữ liệu",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
