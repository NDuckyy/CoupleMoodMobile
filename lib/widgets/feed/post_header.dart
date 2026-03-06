import 'package:couple_mood_mobile/utils/time_utils.dart';
import 'package:couple_mood_mobile/screens/feed/create_edit_post_screen.dart';
import 'package:couple_mood_mobile/providers/post/post_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import '../../models/post/post_model.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;

  const PostHeader({super.key, required this.post});

  void _onMenuSelected(BuildContext context, String value) async {
    final provider = context.read<PostProvider>();

    if (value == "edit") {
      final updated = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CreateEditPostScreen(post: post)),
      );

      if (updated == true) {
        provider.loadFeeds();
      }
    }

    if (value == "delete") {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Xoá bài viết?"),
          content: const Text("Hành động này không thể hoàn tác."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("Huỷ"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text("Xoá", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final success = await provider.deletePost(post.id);

        if (context.mounted) {
          showMsg(
            context,
            success ? "Đã xoá bài viết" : "Xoá thất bại",
            success,
          );
        }
      }
    }
  }

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

        /// MENU
        if (post.isOwner)
          PopupMenuButton<String>(
            onSelected: (value) => _onMenuSelected(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text("Chỉnh sửa"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "delete",
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Xoá", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
