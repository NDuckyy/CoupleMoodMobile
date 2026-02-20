import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/search_member/member_search_header.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/search_member/search_bar.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/search_member/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberSearchScreen extends StatefulWidget {
  const MemberSearchScreen({super.key});

  @override
  State<MemberSearchScreen> createState() => _MemberSearchScreenState();
}

class _MemberSearchScreenState extends State<MemberSearchScreen> {
  final searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoupleInvitationProvider>().searchMembers(null, 1);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<CoupleInvitationProvider>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !provider.isLoading &&
        provider.hasMore) {
      provider.searchMembers(searchController.text, provider.currentPage + 1);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invitationProvider = context.watch<CoupleInvitationProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await invitationProvider.searchMembers(searchController.text, 1);
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MemberSearchHeader(
                    invitedCount: invitationProvider.inviteCount,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: UserSearchBar(
                  controller: searchController,
                  onSearch: (value) {
                    invitationProvider.searchMembers(value, 1);
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
              SliverToBoxAdapter(
                child: invitationProvider.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
