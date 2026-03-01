import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post/post_model.dart';
import '../../providers/post/post_detail_provider.dart';
import '../../widgets/feed/post_comment_bottom_sheet.dart';

class PostActions extends StatelessWidget {
  final PostModel post;

  const PostActions({super.key, required this.post});

  void _openComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => PostDetailProvider()..init(post.id),
        child: PostCommentBottomSheet(postId: post.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
          color: post.isLikedByMe ? Colors.red : null,
        ),
        const SizedBox(width: 6),
        Text(post.likeCount.toString()),

        const SizedBox(width: 20),

        GestureDetector(
          onTap: () => _openComments(context),
          child: Row(
            children: [
              const Icon(Icons.comment_outlined),
              const SizedBox(width: 6),
              Text(post.commentCount.toString()),
            ],
          ),
        ),
      ],
    );
  }
}
