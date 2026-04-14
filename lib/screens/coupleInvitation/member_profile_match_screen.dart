import 'package:couple_mood_mobile/models/coupleInvitation/member_response.dart';
import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/dialog/invite_dialog.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/budget_card.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/profile_section_title.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/relationship_badge.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MemberProfileMatchScreen extends StatefulWidget {
  final int userId;

  const MemberProfileMatchScreen({super.key, required this.userId});

  @override
  State<MemberProfileMatchScreen> createState() =>
      _MemberProfileMatchScreenState();
}

class _MemberProfileMatchScreenState extends State<MemberProfileMatchScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CoupleInvitationProvider>().getMemberProfile(widget.userId);
    });
  }

  void _sendInvitation(int memberProfileId, String message) async {
    final invitationProvider = context.read<CoupleInvitationProvider>();
    try {
      await invitationProvider.sendInvitation(memberProfileId, message);
      if (invitationProvider.error != null) {
        if (!mounted) return;
        showMsg(context, "${invitationProvider.error}", false);
        context.pop();
        return;
      }
      if (!mounted) return;
      showMsg(context, "Lời mời đã được gửi thành công", true);
      invitationProvider.searchMembers(null, 1);
      context.pop();
    } catch (e) {
      showMsg(context, "Lỗi khi gửi lời mời: ${e.toString()}", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CoupleInvitationProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = provider.userData;
    final profile = user?.memberProfile;

    if (profile == null) {
      return const Scaffold(body: Center(child: Text("Không có dữ liệu")));
    }

    final age = profile.age;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDC5F5), Color(0xFFB388EB), Color(0xFF72DDF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _glassButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.pop(),
                  ),
                ),
              ),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFDC5F5), Color(0xFF8093F1)],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: user?.avatarUrl != null
                          ? NetworkImage(user!.avatarUrl!)
                          : null,
                      backgroundColor: Colors.white24,
                      child: user?.avatarUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    age != null
                        ? "${profile.fullName}, $age"
                        : profile.fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  RelationshipBadge(status: profile.relationshipStatus),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ListView(
                    children: [
                      const ProfileSectionTitle("Giới thiệu"),
                      const SizedBox(height: 8),
                      Text(
                        profile.bio?.isNotEmpty == true
                            ? profile.bio!
                            : "Người này hơi bí ẩn đó 🥺",
                      ),

                      const SizedBox(height: 20),

                      if (profile.gender != null) ...[
                        const ProfileSectionTitle("Giới tính"),
                        const SizedBox(height: 8),
                        Text(profile.gender!),
                        const SizedBox(height: 20),
                      ],

                      const ProfileSectionTitle("Ngân sách hẹn hò"),
                      const SizedBox(height: 12),
                      BudgetCard(
                        min: profile.budgetMin ?? 0,
                        max: profile.budgetMax,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    showInviteDialog(
                      context: context,
                      user: MemberResponse(
                        memberProfileId: user!.memberProfile!.id,
                        userId: user.id,
                        fullName: user.fullName,
                        relationshipStatus:
                            user.memberProfile!.relationshipStatus,
                        canSendInvitation: true,
                      ),
                      onSend: (message) =>
                          _sendInvitation(user.memberProfile!.id, message),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8093F1), Color(0xFFB388EB)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Center(
                      child: provider.isSendingInvitation
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              "Gửi lời mời 💖",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _glassButton({required IconData icon, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Icon(icon, size: 22),
    ),
  );
}
