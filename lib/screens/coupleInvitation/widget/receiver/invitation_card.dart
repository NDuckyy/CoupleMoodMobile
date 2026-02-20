import 'package:couple_mood_mobile/models/coupleInvitation/received_response.dart';
import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InvitationCard extends StatelessWidget {
  final ReceivedResponse invitation;

  const InvitationCard({required this.invitation, super.key});
  void _acceptInvitation(BuildContext context) async {
    final provider = context.read<CoupleInvitationProvider>();
    await provider.acceptInvitation(invitation.invitationId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: invitation.senderAvatarUrl != null
                    ? NetworkImage(invitation.senderAvatarUrl!)
                    : null,
                child: invitation.senderAvatarUrl == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(
                            "member_profile_match",
                            extra: {'userId': invitation.senderMemberId},
                          );
                        },
                        child: Ink(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: Text(
                              invitation.senderName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invitation.message,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (invitation.status == "PENDING")
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      // await invitationProvider
                      //     .rejectInvitation(invitation.invitationId);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Từ chối"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptInvitation(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB388EB),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Chấp nhận",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

          /// Nếu không còn pending thì hiển thị trạng thái
          if (invitation.status != "PENDING")
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                invitation.status,
                style: TextStyle(
                  color: invitation.status == "ACCEPTED"
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
