import 'package:couple_mood_mobile/models/report/report_target_type.dart';
import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:couple_mood_mobile/providers/post/my_posts_provider.dart';
import 'package:couple_mood_mobile/utils/time_utils.dart';
import 'package:couple_mood_mobile/screens/feed/create_edit_post_screen.dart';
import 'package:couple_mood_mobile/providers/post/post_provider.dart';
import 'package:couple_mood_mobile/widgets/report/report_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import '../../models/post/post_model.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;

  const PostHeader({super.key, required this.post});

  void _onMenuSelected(BuildContext context, String value) async {
    final feedProvider = context.read<PostProvider>();
    final myPostsProvider = context.read<MyPostsProvider>();

    if (value == "report") {
      showReportBottomSheet(
        context: context,
        targetId: post.id,
        targetType: ReportTargetType.post,
      );
      return;
    }

    if (value == "edit") {
      final updated = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CreateEditPostScreen(post: post)),
      );

      if (updated == true) {
        feedProvider.loadFeeds();
        myPostsProvider.refresh();
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
        final success = await feedProvider.deletePost(post.id);

        if (success) {
          myPostsProvider.refresh();
        }

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
    final accessories = post.author?.equippedAccessories ?? [];

    final frame = accessories.cast<MemberAccessory?>().firstWhere(
      (e) => e?.type == "FRAME",
      orElse: () => null,
    );

    final badge = accessories.cast<MemberAccessory?>().firstWhere(
      (e) => e?.type == "BADGE",
      orElse: () => null,
    );
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            /// AVATAR
            CircleAvatar(
              radius: 20,
              backgroundImage: post.author?.avatar != null
                  ? NetworkImage(post.author!.avatar!)
                  : null,
              child: post.author?.avatar == null
                  ? const Icon(Icons.person)
                  : null,
            ),

            /// FRAME
            if (frame?.thumbnailUrl != null && frame!.thumbnailUrl!.isNotEmpty)
              Transform.scale(
                scale: 1.2,
                child: Image.network(
                  frame.thumbnailUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    post.author?.fullName ?? "Bạn",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  if (badge?.thumbnailUrl != null) ...[
                    const SizedBox(width: 4),
                    Image.network(badge!.thumbnailUrl!, width: 16, height: 16),
                  ],
                ],
              ),

              Text(
                timeAgo(post.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),

        /// MENU
        PopupMenuButton<String>(
          onSelected: (value) => _onMenuSelected(context, value),
          itemBuilder: (context) {
            if (post.isOwner) {
              return [
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
              ];
            }

            ///  USER KHÁC → chỉ có REPORT
            return [
              const PopupMenuItem(
                value: "report",
                child: Row(
                  children: [
                    Icon(Icons.flag, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Báo cáo", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}
