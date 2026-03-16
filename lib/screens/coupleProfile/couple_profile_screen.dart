import 'package:couple_mood_mobile/providers/couple_provider.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:couple_mood_mobile/widgets/loading.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final coupleProvider = context.watch<CoupleProvider>();
    final couple = coupleProvider.couple;
    if (coupleProvider.isLoading) {
      return const Scaffold(body: Center(child: Loading()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cặp đôi"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      couple.coupleName,
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
                        _buildAvatar(couple.member1AvatarUrl),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 32,
                          ),
                        ),

                        _buildAvatar(couple.member2AvatarUrl),
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

                    _buildStatsCard(
                      couple.aniversaryDate,
                      couple.totalPoints,
                      couple.interactionPoints,
                    ),

                    const SizedBox(height: 20),

                    _buildInfoCard(
                      title: "Tính cách cặp đôi",
                      value: couple.couplePersonalityTypeName,
                      description: couple.couplePersonalityTypeDescription,
                    ),

                    const SizedBox(height: 16),

                    /// Mood
                    _buildInfoCard(
                      title: "Mood cặp đôi",
                      value: couple.coupleMoodTypeName,
                      description: couple.coupleMoodTypeDescription,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return CircleAvatar(
      radius: 45,
      backgroundColor: Colors.white,
      child: CircleAvatar(radius: 42, backgroundImage: NetworkImage(url)),
    );
  }

  Widget _buildStatsCard(
    String anniversaryDate,
    int totalPoints,
    int interactionPoints,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.favorite,
            color: const Color(0xFFF7AEF8),
            label: "Kiỷ niệm",
            value: anniversaryDate,
          ),

          _divider(),

          _buildStatItem(
            icon: Icons.workspace_premium,
            color: const Color(0xFFB388EB),
            label: "Couple point",
            value: "$totalPoints",
          ),

          _divider(),

          _buildStatItem(
            icon: Icons.flash_on,
            color: const Color(0xFF72DDF7),
            label: "Điểm tương tác",
            value: "$interactionPoints",
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(height: 40, width: 1, color: Colors.grey.shade200);
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB388EB), Color(0xFF8093F1)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 18,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8093F1),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, height: 1.4),
          ),
        ],
      ),
    );
  }
}
