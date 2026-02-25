import 'package:couple_mood_mobile/screens/coupleInvitation/widget/sent/sent_invitation_card.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';

class SentInvitationScreen extends StatefulWidget {
  const SentInvitationScreen({super.key});

  @override
  State<SentInvitationScreen> createState() => _SentInvitationScreenState();
}

class _SentInvitationScreenState extends State<SentInvitationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoupleInvitationProvider>().fetchSentInvitations(null, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final invitationProvider = context.watch<CoupleInvitationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Các lời mời đã gửi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await invitationProvider.fetchSentInvitations(null, 1);
        },
        child: invitationProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : invitationProvider.sentInvitations.isEmpty
            ? EmptyStateWidget(
                icon: Icons.heart_broken,
                title: "Chưa có lời mời nào",
                description:
                    "Bạn chưa gửi lời mời ghép đôi nào đến người dùng khác.",
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: invitationProvider.sentInvitations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final user = invitationProvider.sentInvitations[index];

                  return SentInvitationCard(invitation: user);
                },
              ),
      ),
    );
  }
}
