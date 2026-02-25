import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/available_time_section.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/budget_card.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/interest_chip.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/profile_section_title.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_profile/relationship_badge.dart';
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

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CoupleInvitationProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider.error != null) {
      return Scaffold(body: Center(child: Text(provider.error!)));
    }

    final profile = provider.userData?.memberProfile;

    if (profile == null) {
      return const Scaffold(body: Center(child: Text("Không có dữ liệu")));
    }

    final age = _calculateAge(profile.dateOfBirth);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 420,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFB388EB), Color(0xFF72DDF7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 150,
                        color: Colors.white,
                      ),
                    ),

                    Container(
                      height: 420,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${profile.fullName}, $age",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          RelationshipBadge(status: profile.relationshipStatus),
                        ],
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileSectionTitle("Bio"),
                      const SizedBox(height: 8),
                      Text(
                        profile.bio?.isNotEmpty == true
                            ? profile.bio!
                            : "Người này chưa cập nhật mô tả 💫",
                      ),

                      const SizedBox(height: 24),

                      const ProfileSectionTitle("Sở thích"),
                      const SizedBox(height: 12),

                      if (profile.interests?.sothich.isNotEmpty == true)
                        InterestChips(interests: profile.interests!.sothich)
                      else
                        const Text("Chưa cập nhật sở thích"),

                      const SizedBox(height: 24),

                      const ProfileSectionTitle("Ngân sách hẹn hò"),
                      const SizedBox(height: 12),
                      BudgetCard(
                        min: profile.budgetMin,
                        max: profile.budgetMax,
                      ),

                      const SizedBox(height: 24),

                      const ProfileSectionTitle("Thời gian rảnh"),
                      const SizedBox(height: 16),
                      AvailableTimeSection(
                        sang: profile.availableTime?.sang ?? [],
                        toi: profile.availableTime?.toi ?? [],
                        cuoiTuan: profile.availableTime?.cuoiTuan ?? [],
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 50,
            left: 16,
            child: _buildCircleButton(
              icon: Icons.arrow_back,
              onTap: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCircleButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Icon(icon, color: Colors.black, size: 22),
    ),
  );
}
