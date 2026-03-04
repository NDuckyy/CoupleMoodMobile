import 'package:couple_mood_mobile/models/coupleInvitation/received_response.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InvitationCard extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final InvitationResponse invitation;

  const InvitationCard({required this.onAccept, required this.onReject, required this.invitation, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF3EDFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFB388EB).withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB388EB).withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar + Name
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFF7AEF8).withOpacity(0.2),
                backgroundImage: invitation.senderAvatarUrl != null
                    ? NetworkImage(invitation.senderAvatarUrl!)
                    : null,
                child: invitation.senderAvatarUrl == null
                    ? const Icon(Icons.person, color: Color(0xFFB388EB))
                    : null,
              ),
              const SizedBox(width: 14),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      "member_profile_match",
                      extra: {'userId': invitation.senderMemberId},
                    );
                  },
                  child: Text(
                    invitation.senderName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              if (invitation.status != "PENDING") _buildStatusBadge(),
            ],
          ),

          const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 14,
                      color: const Color(0xFFB388EB),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Lời nhắn từ đối phương",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  invitation.message,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (invitation.status == "PENDING")
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      onReject();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE57373),
                      side: const BorderSide(color: Color(0xFFE57373)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Từ chối",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onAccept(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB388EB),
                      elevation: 6,
                      shadowColor: const Color(0xFFB388EB).withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Chấp nhận",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;

    switch (invitation.status) {
      case "ACCEPTED":
        color = const Color(0xFF4CAF50);
        break;
      default:
        color = const Color(0xFFE57373);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        invitation.status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
