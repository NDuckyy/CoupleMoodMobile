import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/member_search_header.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/search_bar.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberSearchScreen extends StatelessWidget {
  const MemberSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    final invitationProvider = context.watch<CoupleInvitationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // await invitationProvider.fetchUsers();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MemberSearchHeader(invitedCount: invitationProvider.inviteCount),
                ),
              ),
              SliverToBoxAdapter(
                child: UserSearchBar(
                  controller: searchController,
                  onChanged: (value) {
                    // invitationProvider.searchUsers(value);
                  },
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return UserCard(user: invitationProvider.users[index]);
                  }, childCount: invitationProvider.users.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
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
