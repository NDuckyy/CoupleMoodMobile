import 'package:couple_mood_mobile/utils/time_utils.dart';
import 'package:flutter/material.dart';
import '../../models/post/post_model.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: post.author.avatar != null
              ? NetworkImage(post.author.avatar!)
              : null,
          child: post.author.avatar == null ? const Icon(Icons.person) : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.author.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                timeAgo(post.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        if (post.isOwner) const Icon(Icons.more_vert),
      ],
    );
  }
}
