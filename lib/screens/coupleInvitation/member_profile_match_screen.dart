import 'package:couple_mood_mobile/models/coupleInvitation/member_response.dart';
import 'package:couple_mood_mobile/models/report/report_target_type.dart';
import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/dialog/invite_dialog.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/info_chip.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/profile_section_card.dart';
import 'package:couple_mood_mobile/utils/profile_utils.dart';
import 'package:couple_mood_mobile/widgets/report/report_bottom_sheet.dart';
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
      context.pop();
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
      backgroundColor: const Color(0xFFF7F0FF),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 HEADER (gradient nhẹ)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEDE7FF), Color(0xFFF5F3FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  /// BACK BUTTON
                  /// BACK BUTTON
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconButton(
                          icon: Icons.arrow_back,
                          onTap: () => context.pop(),
                        ),

                        /// ✅ REPORT BUTTON
                        _iconButton(
                          icon: Icons.flag_outlined,
                          onTap: () {
                            showReportBottomSheet(
                              context: context,
                              targetId: widget.userId,
                              targetType: ReportTargetType.user,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  /// AVATAR
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user?.avatarUrl != null
                          ? NetworkImage(user!.avatarUrl!)
                          : null,
                      child: user?.avatarUrl == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// NAME
                  Text(
                    age != null && age > 0
                        ? "${profile.fullName}, $age"
                        : profile.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// STATUS
                  // _statusBadge(profile.relationshipStatus),
                ],
              ),
            ),

            /// 🔹 CONTENT
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
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

                  if (profile.personalityDescription != null &&
                      profile.personalityDescription!.isNotEmpty)
                    ProfileSectionCard(
                      title: "Tính cách",
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.personalityDescription!
                            .map((e) => InfoChip("✨ $e"))
                            .toList(),
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
                          if (profile.gender != null) ...[
                            if (profile.gender == "MALE")
                              InfoChip("Nam")
                            else
                              InfoChip("Nữ"),
                          ],
                          if (age != null && age > 0) InfoChip("$age tuổi"),
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
                          if (profile.educationLevel != null &&
                              profile.educationLevel!.isNotEmpty)
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
                                  : "🚭 Không hút thuốc",
                            ),
                          if (profile.hasPet != null)
                            InfoChip(
                              profile.hasPet!
                                  ? "🐶 Có thú cưng"
                                  : "❌ Không nuôi thú cưng",
                            ),
                          if (profile.favoritePets != null &&
                              profile.favoritePets!.isNotEmpty)
                            InfoChip(
                              "Thích ${profile.favoritePets!.join(", ")}",
                            ),
                        ],
                      ),
                    ),

                  if (profile.interests != null &&
                      profile.interests!.isNotEmpty)
                    ProfileSectionCard(
                      title: "Sở thích",
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.interests!
                            .map((e) => InfoChip(e))
                            .toList(),
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

            /// 🔹 CTA BUTTON
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
                    borderRadius: BorderRadius.circular(20),
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
    );
  }

  /// 🔹 BUTTON ICON
  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
          ],
        ),
        child: Icon(icon),
      ),
    );
  }

  /// 🔹 STATUS BADGE
  Widget _statusBadge(String status) {
    if (status.isEmpty) return const SizedBox.shrink();

    String text = status;

    if (status == "SINGLE") {
      text = "Độc thân";
    } else if (status == "IN_RELATIONSHIP") {
      text = "Đang hẹn hò";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF8093F1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF8093F1),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
