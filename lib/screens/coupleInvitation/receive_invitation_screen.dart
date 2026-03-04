import 'package:couple_mood_mobile/screens/coupleInvitation/widget/receiver/invitation_card.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/receiver/receive_header.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
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
  void _acceptInvitation(BuildContext context, int invitationId) async {
    final provider = context.read<CoupleInvitationProvider>();
     await provider.acceptInvitation(invitationId);
    if (provider.error != null) {
      if (context.mounted) {
        showMsg(context, provider.error!, false);
      }
    } else {
      if (context.mounted) {
        showMsg(context, "Đã chấp nhận lời mời", true);
      }
    }
  }

  void _rejectInvitation(BuildContext context, int invitationId) async {
    final provider = context.read<CoupleInvitationProvider>();
    await provider.rejectInvitation(invitationId);
    if (provider.error != null) {
      if (context.mounted) {
        showMsg(context, provider.error!, false);
      }
    } else {
      if (context.mounted) {
        showMsg(context, "Đã từ chối lời mời", true);
      }
    }
  }

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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await invitationProvider.fetchReceivedInvitations(null, 1);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ReceiveHeader(),
                ),
              ),

              if (invitationProvider.isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (invitationProvider.receivedInvitations.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateWidget(
                    icon: Icons.heart_broken,
                    title: "Chưa có lời mời nào",
                    description:
                        "Bạn chưa nhận được lời mời ghép đôi nào từ người dùng khác.",
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final invitation =
                            invitationProvider.receivedInvitations[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: InvitationCard(
                            invitation: invitation,
                            onAccept: () => _acceptInvitation(
                              context,
                              invitation.invitationId,
                            ),
                            onReject: () => _rejectInvitation(
                              context,
                              invitation.invitationId,
                            ),
                          ),
                        );
                      },
                      childCount: invitationProvider.receivedInvitations.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
