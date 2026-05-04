import 'package:couple_mood_mobile/providers/post/my_posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/post/post_model.dart';
import 'post_header.dart';
import 'post_media.dart';
import 'post_actions.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  String _buildFullText() {
    final tagsText = post.hashTags
        .map((tag) => tag.startsWith("#") ? tag : "#$tag")
        .join(" ");

    return "${post.content} ${tagsText.isNotEmpty ? tagsText : ""}";
  }

  bool _isTextOverflow(BuildContext context) {
    final fullText = _buildFullText();

    final textPainter = TextPainter(
      text: TextSpan(text: fullText, style: const TextStyle(fontSize: 14)),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 64);

    return textPainter.didExceedMaxLines;
  }

  Future<void> _openDetail(BuildContext context) async {
    final needRefresh = await context.pushNamed(
      'post_detail',
      pathParameters: {'postId': post.id.toString()},
    );

    if (needRefresh == true) {
      context.read<MyPostsProvider>().refresh();
    }
  }

  Widget _buildContent() {
    final tags = post.hashTags
        .map((tag) => tag.startsWith("#") ? tag : "#$tag")
        .join(" ");

    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
          color: Colors.black87,
        ),
        children: [
          TextSpan(text: "${post.content} "),
          if (tags.isNotEmpty)
            TextSpan(
              text: tags,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOverflow = _isTextOverflow(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openDetail(context),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFDDDEE3), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeader(post: post),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: () => _openDetail(context),
                child: _buildContent(),
              ),

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

              const SizedBox(height: 12),

              PostActions(post: post),
            ],
          ),
        ),
      ),
    );
  }
}
