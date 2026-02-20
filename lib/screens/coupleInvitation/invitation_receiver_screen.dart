import 'package:couple_mood_mobile/screens/coupleInvitation/widget/receiver/invitation_card.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';

class ReceiveInvitationScreen extends StatefulWidget {
  const ReceiveInvitationScreen({super.key});

  @override
  State<ReceiveInvitationScreen> createState() =>
      _ReceiveInvitationScreenState();
}

class _ReceiveInvitationScreenState extends State<ReceiveInvitationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoupleInvitationProvider>().fetchReceivedInvitations(
        null,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final invitationProvider = context.watch<CoupleInvitationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lời mời ghép đôi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await invitationProvider.fetchReceivedInvitations(null, 1);
        },
        child: invitationProvider.receivedInvitations.isEmpty
            ? EmptyStateWidget(
                icon: Icons.heart_broken,
                title: "Chưa có lời mời nào",
                description:
                    "Bạn chưa nhận được lời mời ghép đôi nào từ người dùng khác.",
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: invitationProvider.receivedInvitations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final user = invitationProvider.receivedInvitations[index];

                  return InvitationCard(invitation: user);
                },
              ),
      ),
    );
  }
}
