import 'package:flutter/material.dart';
import '../../models/post/post_model.dart';
import 'post_header.dart';
import 'post_media.dart';
import 'post_actions.dart';
import 'hashtag_wrap.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(post: post),
            const SizedBox(height: 12),

            /// Content
            Text(post.content),

            const SizedBox(height: 12),

            /// Media
            if (post.mediaPayload.isNotEmpty)
              PostMedia(mediaList: post.mediaPayload),

            if (post.hashTags.isNotEmpty) ...[
              const SizedBox(height: 12),
              HashTagWrap(tags: post.hashTags),
            ],

            const SizedBox(height: 12),
            PostActions(post: post),
          ],
        ),
      ),
    );
  }
}
