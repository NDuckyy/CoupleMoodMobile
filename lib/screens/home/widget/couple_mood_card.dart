import 'package:couple_mood_mobile/models/mood/current_mood.dart';
import 'package:flutter/material.dart';

class CoupleMoodCard extends StatelessWidget {
  final CurrentMood? coupleCurrentMood;

  const CoupleMoodCard({super.key, required this.coupleCurrentMood});

  @override
  Widget build(BuildContext context) {
    if (coupleCurrentMood == null) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFB388EB), Color(0xFF72DDF7)],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFB388EB), Color(0xFF72DDF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMember(
                  label: "Bạn",
                  avatarUrl: coupleCurrentMood?.memberAvatarUrl ?? "",
                  mood: coupleCurrentMood?.currentMood ?? "Chưa cập nhật",
                  align: CrossAxisAlignment.center,
                ),
              ),

              Expanded(child: _buildCenter()),

              Expanded(
                child: _buildMember(
                  label: "Đối phương",
                  avatarUrl: coupleCurrentMood?.partnerAvatarUrl ?? "",
                  mood: coupleCurrentMood?.partnerMood ?? "Chưa cập nhật",
                  align: CrossAxisAlignment.center,
                ),
              ),
            ],
          ),

          if (coupleCurrentMood?.hasCoupleMood == true &&
              coupleCurrentMood?.description != null) ...[
            const SizedBox(height: 12),
            Text(
              coupleCurrentMood!.description!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMember({
    required String label,
    required String avatarUrl,
    required String mood,
    required CrossAxisAlignment align,
  }) {
    return Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (avatarUrl.isNotEmpty && avatarUrl != "null") ...[
          CircleAvatar(radius: 26, backgroundImage: NetworkImage(avatarUrl)),
        ] else ...[
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white54,
            child: const Icon(Icons.person, color: Colors.white70, size: 28),
          ),
        ],
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: align == CrossAxisAlignment.start
              ? TextAlign.left
              : TextAlign.right,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Flexible(
          child: Text(
            mood,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildCenter() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (coupleCurrentMood?.isCouple == false)
            const Icon(Icons.person_add_alt, color: Colors.white, size: 28)
          else if (coupleCurrentMood?.hasCoupleMood != true ||
              coupleCurrentMood?.coupleMood == null)
            const Icon(Icons.favorite_border, color: Colors.white, size: 28)
          else ...[
            Text(
              coupleCurrentMood!.coupleMood!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Icon(Icons.favorite, color: Colors.white),
          ],
        ],
      ),
    );
  }
}
