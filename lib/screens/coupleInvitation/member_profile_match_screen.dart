import 'package:couple_mood_mobile/models/coupleInvitation/member_response.dart';
import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/dialog/invite_dialog.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/info_chip.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/profile_section_card.dart';
import 'package:couple_mood_mobile/utils/profile_utils.dart';
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
    final provider = context.read<CoupleInvitationProvider>();
    await provider.sendInvitation(memberProfileId, message);

    if (!mounted) return;

    if (provider.error != null) {
      showMsg(context, provider.error!, false);
      return;
    }

    showMsg(context, "Đã gửi lời mời 💖", true);
    context.pop();
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
              /// 🔹 BACK
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _glassButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.pop(),
                  ),
                ),
              ),

              /// 🔹 HEADER
              Column(
                children: [
                  CircleAvatar(
                    radius: 60,
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
                  const SizedBox(height: 10),
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
                  _statusBadge(profile.relationshipStatus),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 CONTENT
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    /// BIO
                    ProfileSectionCard(
                      title: "Giới thiệu",
                      child: Text(
                        profile.bio?.isNotEmpty == true
                            ? profile.bio!
                            : "Người này hơi bí ẩn đó 🥺",
                      ),
                    ),

                    /// BASIC
                    if (profile.gender != null ||
                        profile.height != null ||
                        profile.weight != null ||
                        age != null)
                      ProfileSectionCard(
                        title: "Thông tin cơ bản",
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (profile.gender != null)
                              InfoChip(profile.gender!),
                            if (age != null) InfoChip("$age tuổi"),
                            if (profile.height != null)
                              InfoChip("${profile.height} cm"),
                            if (profile.weight != null)
                              InfoChip("${profile.weight} kg"),
                          ],
                        ),
                      ),

                    /// JOB
                    if (profile.jobTitle != null ||
                        profile.educationLevel != null)
                      ProfileSectionCard(
                        title: "Công việc & học vấn",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (profile.jobTitle != null)
                              Text("💼 ${profile.jobTitle}"),
                            if (profile.educationLevel != null)
                              Text("🎓 ${profile.educationLevel}"),
                          ],
                        ),
                      ),

                    /// LOCATION
                    if (profile.city != null || profile.district != null)
                      ProfileSectionCard(
                        title: "Khu vực",
                        child: Text(
                          formatLocation(profile.city, profile.district),
                        ),
                      ),

                    /// LIFESTYLE
                    if (profile.smoking != null ||
                        profile.hasPet != null ||
                        profile.favoritePets != null)
                      ProfileSectionCard(
                        title: "Lối sống",
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (profile.smoking != null)
                              InfoChip(
                                profile.smoking!
                                    ? "🚬 Hút thuốc"
                                    : "🚭 Không hút",
                              ),
                            if (profile.hasPet != null)
                              InfoChip(
                                profile.hasPet!
                                    ? "🐶 Có thú cưng"
                                    : "❌ Không nuôi",
                              ),
                            if (profile.favoritePets != null)
                              InfoChip("Thích ${profile.favoritePets}"),
                          ],
                        ),
                      ),

                    /// BUDGET
                    if (profile.budgetMin != null || profile.budgetMax != null)
                      ProfileSectionCard(
                        title: "Ngân sách hẹn hò",
                        child: Text(
                          formatBudget(profile.budgetMin, profile.budgetMax),
                        ),
                      ),
                  ],
                ),
              ),

              /// 🔹 CTA
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    showInviteDialog(
                      context: context,
                      user: MemberResponse(
                        memberProfileId: profile.id,
                        userId: user!.id,
                        fullName: user.fullName,
                        relationshipStatus: profile.relationshipStatus,
                        canSendInvitation: true,
                      ),
                      onSend: (message) => _sendInvitation(profile.id, message),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8093F1), Color(0xFFB388EB)],
                      ),
                    ),
                    child: const Center(
                      child: Text(
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

  Widget _glassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }

  Widget _statusBadge(String status) {
    if (status.isEmpty) return const SizedBox.shrink();
    
    if (status == "SINGLE") {
      status = "Độc thân";
    } else if (status == "IN_RELATIONSHIP") {
      status = "Đang hẹn hò";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status),
    );
  }
}
