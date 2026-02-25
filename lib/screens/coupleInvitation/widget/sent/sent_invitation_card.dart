import 'package:couple_mood_mobile/models/coupleInvitation/received_response.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SentInvitationCard extends StatelessWidget {
  final InvitationResponse invitation;

  const SentInvitationCard({required this.invitation, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF3EDFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFB388EB).withOpacity(0.25),
          width: 1.2,
        ),
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
                      extra: {'userId': invitation.receiverMemberId},
                    );
                  },
                  child: Text(
                    invitation.receiverName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              _buildStatusBadge(),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFF7F3FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFB388EB).withOpacity(0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB388EB).withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    invitation.message,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;

    switch (invitation.status) {
      case "ACCEPTED":
        color = const Color(0xFF72DDF7);
        break;
      case "PENDING":
        color = const Color(0xFF8093F1);
        break;
      default:
        color = Colors.redAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
