import 'package:flutter/material.dart';
import '../../models/post/post_model.dart';

class PostActions extends StatelessWidget {
  final PostModel post;

  const PostActions({super.key, required this.post});

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

        const Icon(Icons.comment_outlined),
        const SizedBox(width: 6),
        Text(post.commentCount.toString()),
      ],
    );
  }
}
