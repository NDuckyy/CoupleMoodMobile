import 'package:couple_mood_mobile/models/coupleInvitation/member_filter.dart';
import 'package:couple_mood_mobile/providers/couple_invitation_provider.dart';
import 'package:couple_mood_mobile/providers/user/edit_profile_provider.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/dialog/filter_sheet.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/search_member/member_search_header.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/search_member/search_bar.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/search_member/swipe_hint.dart';
import 'package:couple_mood_mobile/screens/coupleInvitation/widget/search_member/user_card.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

class MemberSearchScreen extends StatefulWidget {
  const MemberSearchScreen({super.key});

  @override
  State<MemberSearchScreen> createState() => _MemberSearchScreenState();
}

class _MemberSearchScreenState extends State<MemberSearchScreen> {
  final searchController = TextEditingController();
  late SwipableStackController _controller;
  int currentIndex = 0;
  MemberFilter? currentFilter;

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController();
    Future.microtask(() async {
      if (!mounted) return;
      final provider = context.read<CoupleInvitationProvider>();
      final editProfileProvider = context.read<EditProfileProvider>();
      await provider.searchMembers(null, 1);
      await editProfileProvider.fetchJobTitles();
      await editProfileProvider.fetchInterests();
    });
  }

  void _sendInvitation(int memberProfileId, String message) async {
    final provider = context.read<CoupleInvitationProvider>();
    try {
      await provider.sendInvitation(memberProfileId, message);

      if (!mounted) return;

      if (provider.error != null) {
        showMsg(context, provider.error!, false);
        return;
      }

      showMsg(context, "Đã gửi lời mời 💖", true);
    } catch (e) {
      showMsg(context, "Lỗi: ${e.toString()}", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CoupleInvitationProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0FF),
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: MemberSearchHeader(
                invitedCount: provider.inviteCount,
                onFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => FractionallySizedBox(
                      heightFactor: 0.85,
                      child: ChangeNotifierProvider.value(
                        value: context.read<EditProfileProvider>(),
                        child: FilterSheet(
                          onApply: (filter) {
                            setState(() {
                              currentFilter = filter;
                              currentIndex = 0;
                              _controller = SwipableStackController();
                            });

                            provider.searchMembers(
                              searchController.text,
                              1,
                              filter: filter,
                            );
                          },
                          initialFilter: currentFilter,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// SEARCH
            UserSearchBar(
              controller: searchController,
              onSearch: (value) async {
                setState(() {
                  currentIndex = 0;
                  _controller = SwipableStackController();
                });

                await provider.searchMembers(value, 1);

                if (!mounted) return;
                setState(() {
                  currentIndex = 0;
                  _controller = SwipableStackController();
                });
              },
            ),

            const SizedBox(height: 10),

            SwipeHint(),

            /// CONTENT
            Expanded(child: _buildContent(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(CoupleInvitationProvider provider) {
    /// LOADING
    if (provider.isLoading && provider.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    /// EMPTY
    if (currentIndex >= provider.users.length) {
      return const EmptyStateWidget(
        icon: Icons.favorite_border,
        title: "Hết người rồi 🥺",
        description: "Không còn ai phù hợp với bạn nữa.",
      );
    }

    /// SWIPE STACK
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SwipableStack(
        controller: _controller,
        itemCount: provider.users.length,
        detectableSwipeDirections: const {
          SwipeDirection.left,
          SwipeDirection.right,
        },

        /// 👉 SWIPE XONG
        onSwipeCompleted: (int index, SwipeDirection direction) {
          currentIndex = index + 1;

          final user = provider.users[index];

          if (direction == SwipeDirection.right) {
            _sendInvitation(user.memberProfileId, "Hi 👋");
          }

          if (index >= provider.users.length - 3) {
            if (provider.hasMore && !provider.isLoading) {
              provider.searchMembers(
                searchController.text,
                provider.currentPage + 1,
              );
            }
          }

          setState(() {});
        },

        builder: (BuildContext context, properties) {
          if (properties.index >= provider.users.length) {
            return const SizedBox.shrink();
          }

          final user = provider.users[properties.index];

          return UserCard(
            user: user,
            onSend: (message) => _sendInvitation(user.memberProfileId, message),
          );
        },

        overlayBuilder: (context, properties) {
          final direction = properties.direction;

          if (direction == null) return const SizedBox();

          final isRight = direction == SwipeDirection.right;

          return Align(
            alignment: isRight ? Alignment.topLeft : Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Transform.rotate(
                angle: isRight ? -0.15 : 0.15,
                child: Opacity(
                  opacity: properties.swipeProgress.abs().clamp(0, 1),
                  child: _SwipeLabel(
                    text: isRight ? "Gửi lời mời" : "Bỏ qua",
                    isLike: isRight,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 🔥 LABEL
class _SwipeLabel extends StatelessWidget {
  final String text;
  final bool isLike;

  const _SwipeLabel({required this.text, required this.isLike});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

        gradient: isLike
            ? const LinearGradient(
                colors: [
                  Color(0xFF8093F1),
                  Color(0xFFB388EB),
                  Color(0xFFF7AEF8),
                ],
              )
            : LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade300],
              ),

        boxShadow: [
          BoxShadow(
            color: isLike
                ? const Color(0xFFB388EB).withOpacity(0.5)
                : Colors.grey.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLike ? Icons.favorite : Icons.thumb_down,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
