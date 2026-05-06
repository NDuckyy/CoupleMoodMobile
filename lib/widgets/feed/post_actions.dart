import 'package:couple_mood_mobile/providers/post/post_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post/post_model.dart';
import '../../providers/post/post_detail_provider.dart';
import '../../widgets/feed/post_comment_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

class PostActions extends StatelessWidget {
  final PostModel post;

  const PostActions({super.key, required this.post});

  void _openComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) => ChangeNotifierProvider(
        create: (_) =>
            PostDetailProvider(ctx.read<PostProvider>())..init(post.id),
        child: PostCommentBottomSheet(postId: post.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    final current = postProvider.findPostById(post.id) ?? post;

    return Row(
      children: [
        ///  LIKE BUTTON
        GestureDetector(
          onTap: current.isLiking
              ? null
              : () => postProvider.toggleLike(current),
          child: Row(
            children: [
              AnimatedScale(
                scale: current.isLikedByMe ? 1.25 : 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: current.isLikedByMe
                        ? [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    current.isLikedByMe
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: current.isLikedByMe
                        ? Colors.red
                        : Colors.grey.shade700,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Text(
                  current.likeCount.toString(),
                  key: ValueKey(current.likeCount),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 24),

        ///  COMMENT BUTTON
        GestureDetector(
          onTap: () => _openComments(context),
          child: Row(
            children: [
              const Icon(Icons.comment_outlined),
              const SizedBox(width: 6),
              Text(
                post.commentCount.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

        const SizedBox(width: 24),

        /// SHARE BUTTON
        GestureDetector(
          onTap: () async {
            final provider = context.read<PostProvider>();

            final link = await provider.getShareLink(post.id);

            if (link != null) {
              Share.share("Xem bài viết này nè 👀\n$link");
            } else {
              showMsg(context, "Không lấy được link chia sẻ", false);
            }
          },
          child: const Icon(Icons.share_outlined),
        ),
      ],
    );
  }
}
