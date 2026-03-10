import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/post/post_model.dart';
import 'post_header.dart';
import 'post_media.dart';
import 'post_actions.dart';
import 'hashtag_wrap.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  bool _isTextOverflow(BuildContext context, String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 14)),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 64);

    return textPainter.didExceedMaxLines;
  }

  void _openDetail(BuildContext context) {
    context.pushNamed(
      'post_detail',
      pathParameters: {'postId': post.id.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOverflow = _isTextOverflow(context, post.content);

    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeader(post: post),
              const SizedBox(height: 12),

              /// PREVIEW CONTENT
              Text(post.content, maxLines: 3, overflow: TextOverflow.ellipsis),

              if (isOverflow)
                GestureDetector(
                  onTap: () => _openDetail(context),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "Xem thêm",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 12),

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
      ),
    );
  }
}
