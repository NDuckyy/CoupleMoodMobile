import 'package:couple_mood_mobile/providers/couple_provider.dart';
import 'package:couple_mood_mobile/screens/coupleProfile/dialog/show_breakup_confirm_dialog.dart';
import 'package:couple_mood_mobile/screens/coupleProfile/widgets/build_avatar.dart';
import 'package:couple_mood_mobile/screens/coupleProfile/widgets/build_info_card.dart';
import 'package:couple_mood_mobile/screens/coupleProfile/widgets/build_stat_card.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:couple_mood_mobile/widgets/loading.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CoupleProfilePage extends StatefulWidget {
  const CoupleProfilePage({super.key});

  @override
  State<CoupleProfilePage> createState() => _CoupleProfilePageState();
}

class _CoupleProfilePageState extends State<CoupleProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<CoupleProvider>().fetchCoupleProfile();
    });
  }

  void _breakupCouple() async {
    final coupleProvider = context.read<CoupleProvider>();
    await coupleProvider.breakupCouple();
    if (coupleProvider.error != null) {
      if (!mounted) return;
      showMsg(context, coupleProvider.error!, false);
    } else {
      if (!mounted) return;
      showMsg(context, 'Chia tay thành công', true);
      context.goNamed("home");
    }
  }

  void _onBreakupPressed() {
    showBreakupConfirmDialog(context: context, onConfirm: _breakupCouple);
  }

  @override
  Widget build(BuildContext context) {
    final coupleProvider = context.watch<CoupleProvider>();
    final couple = coupleProvider.couple;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cặp đôi"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          if (couple != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  context.pushNamed(
                    "edit_couple_profile",
                    extra: {
                      "coupleName": couple.coupleName,
                      "anniversaryDate": couple.aniversaryDate,
                      "budgetMin": couple.budgetMin,
                      "budgetMax": couple.budgetMax,
                    },
                  );
                },
              ),
            ),
        ],
      ),
      backgroundColor: Colors.white,
      body: coupleProvider.isLoading
          ? const Center(child: Loading())
          : SafeArea(
              child: SingleChildScrollView(
                child: couple == null
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: EmptyStateWidget(
                              icon: Icons.people_outline,
                              title: "Chưa có cặp đôi",
                              description:
                                  "Hãy kết nối với người yêu để bắt đầu hành trình 💕",
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            couple.coupleName ?? "Cặp đôi chưa đặt tên",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Avatars
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BuildAvatar(url: couple.member1AvatarUrl),

                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                  size: 32,
                                ),
                              ),

                              BuildAvatar(url: couple.member2AvatarUrl),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// Names
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 18),
                              children: [
                                TextSpan(
                                  text: couple.member1Name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8093F1),
                                  ),
                                ),
                                const TextSpan(
                                  text: "  &  ",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextSpan(
                                  text: couple.member2Name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB388EB),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          BuildStatCard(
                            anniversaryDate: couple.aniversaryDate ?? "Chưa có",
                            totalPoints: couple.totalPoints,
                            interactionPoints: couple.interactionPoints,
                            budgetMin: couple.budgetMin,
                            budgetMax: couple.budgetMax,
                          ),

                          const SizedBox(height: 20),

                          BuildInfoCard(
                            title: "Tính cách cặp đôi",
                            value:
                                couple.couplePersonalityTypeName?.isNotEmpty ==
                                    true
                                ? couple.couplePersonalityTypeName!
                                : "Chưa có",
                            description:
                                couple
                                        .couplePersonalityTypeDescription
                                        ?.isNotEmpty ==
                                    true
                                ? couple.couplePersonalityTypeDescription!
                                : "Hãy hoàn thành bài trắc nghiệm tính cách để khám phá tính cách cặp đôi của bạn",
                          ),

                          const SizedBox(height: 16),

                          /// Mood
                          BuildInfoCard(
                            title: "Mood cặp đôi",
                            value: couple.coupleMoodTypeName?.isNotEmpty == true
                                ? couple.coupleMoodTypeName!
                                : "Chưa có",
                            description:
                                couple.coupleMoodTypeDescription?.isNotEmpty ==
                                    true
                                ? couple.coupleMoodTypeDescription!
                                : "Hãy chia sẻ cảm xúc hàng ngày để khám phá mood cặp đôi của bạn",
                          ),

                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: () => _onBreakupPressed(),
                                  child: Ink(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFFB388EB),
                                          Color(0xFFF7AEF8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Chia tay',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
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
