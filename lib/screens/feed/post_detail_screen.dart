import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/models/post/comment_model.dart';
import 'package:couple_mood_mobile/models/post/post_detail_model.dart';
import 'package:couple_mood_mobile/models/post/post_model.dart';
import 'package:couple_mood_mobile/models/report/report_target_type.dart';
import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:couple_mood_mobile/providers/post/post_provider.dart';
import 'package:couple_mood_mobile/screens/feed/create_edit_post_screen.dart';
import 'package:couple_mood_mobile/widgets/feed/comment_item_skeleton.dart';
import 'package:couple_mood_mobile/widgets/report/report_bottom_sheet.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/post/post_detail_provider.dart';
import '../../widgets/feed/post_media.dart';
import '../../widgets/feed/comment_item.dart';
import '../../utils/time_utils.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  CommentModel? _editingComment;
  int? _replyingToCommentId;
  String? _replyingToName;

  // ================== AUTHOR AVATAR WITH FRAME ==================
  Widget _buildAuthorAvatar(PostDetailModel post) {
    final accessories = post.author.equippedAccessories ?? [];

    final frame = accessories.cast<MemberAccessory?>().firstWhere(
      (e) => e?.type == "FRAME",
      orElse: () => null,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: post.author.avatar != null
              ? CachedNetworkImageProvider(post.author.avatar!)
              : null,
          child: post.author.avatar == null
              ? const Icon(Icons.person, size: 20)
              : null,
        ),
        if (frame?.thumbnailUrl != null && frame!.thumbnailUrl!.isNotEmpty)
          Transform.scale(
            scale: 1.3,
            child: CachedNetworkImage(
              imageUrl: frame.thumbnailUrl!,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              memCacheWidth: 120,
              placeholder: (_, __) => const SizedBox.shrink(),
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }

  // ================== BADGE ==================
  Widget _buildBadge(PostDetailModel post) {
    final accessories = post.author.equippedAccessories ?? [];
    final badge = accessories.cast<MemberAccessory?>().firstWhere(
      (e) => e?.type == "BADGE",
      orElse: () => null,
    );

    if (badge?.thumbnailUrl == null || badge!.thumbnailUrl!.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: CachedNetworkImage(
        imageUrl: badge.thumbnailUrl!,
        width: 18,
        height: 18,
        fit: BoxFit.cover,
        memCacheWidth: 60,
      ),
    );
  }

  void _showCommentOptions(CommentModel comment) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (comment.isOwner) ...[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Chỉnh sửa"),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _editingComment = comment;
                      _replyingToCommentId = null;
                      _replyingToName = null;
                      _controller.text = comment.content;
                      _controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: _controller.text.length),
                      );
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text("Xoá", style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    Navigator.pop(context);
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text("Xoá bình luận?"),
                        content: const Text(
                          "Hành động này không thể hoàn tác.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text("Huỷ"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text(
                              "Xoá",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      final success = await context
                          .read<PostDetailProvider>()
                          .deleteComment(comment.id);
                      if (mounted) {
                        showMsg(
                          context,
                          success ? "Đã xoá bình luận" : "Xoá thất bại",
                          success,
                        );
                      }
                    }
                  },
                ),
              ],
              if (!comment.isOwner)
                ListTile(
                  leading: const Icon(Icons.flag, color: Colors.red),
                  title: const Text(
                    "Báo cáo",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showReportBottomSheet(
                      context: context,
                      targetId: comment.id,
                      targetType: ReportTargetType.comment,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showPostOptions() {
    final provider = context.read<PostDetailProvider>();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Chỉnh sửa bài viết"),
                onTap: () async {
                  Navigator.pop(context);
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateEditPostScreen(
                        post: PostModel.fromDetail(provider.post!),
                      ),
                    ),
                  );
                  if (updated == true) {
                    await provider.loadPostDetail(provider.post!.id);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  "Xoá bài viết",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Navigator.pop(context);
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
                          child: const Text(
                            "Xoá",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final success = await context
                        .read<PostDetailProvider>()
                        .deletePost(widget.postId);
                    if (!mounted) return;

                    showMsg(
                      context,
                      success ? "Đã xoá bài viết" : "Xoá thất bại",
                      success,
                    );

                    if (success) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostDetailProvider>().init(widget.postId);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 200) {
        context.read<PostDetailProvider>().loadComments(widget.postId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostDetailProvider>();

    if (provider.loading || provider.post == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final post = provider.post!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chi tiết bài viết"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                context.pop(); // có stack → back bình thường
              } else {
                context.goNamed('newsfeed'); // deep link → về feed
              }
            },
          ),
          actions: [
            if (post.isOwner)
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: _showPostOptions,
              ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      _buildAuthorAvatar(post),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  post.author.fullName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildBadge(post),
                              ],
                            ),
                            Text(
                              timeAgo(post.createdAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  _buildContentWithTags(post),
                  const SizedBox(height: 12),

                  if (post.mediaPayload.isNotEmpty)
                    PostMedia(mediaList: post.mediaPayload),

                  const SizedBox(height: 16),

                  Consumer<PostProvider>(
                    builder: (context, postProvider, _) {
                      final updatedPost = postProvider.posts
                          .where((p) => p.id == post.id)
                          .firstOrNull;
                      if (updatedPost == null) return const SizedBox();

                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                postProvider.toggleLikeById(updatedPost.id),
                            child: Row(
                              children: [
                                Icon(
                                  updatedPost.isLikedByMe
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: updatedPost.isLikedByMe
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  updatedPost.likeCount.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Row(
                            children: [
                              const Icon(Icons.comment_outlined),
                              const SizedBox(width: 6),
                              Text(
                                updatedPost.commentCount.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  const Divider(height: 32),
                  const SizedBox(height: 20),

                  const Text(
                    "Bình luận",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Column(
                    children: provider.comments.map((c) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommentItem(
                            comment: c,
                            onReply: () {
                              setState(() {
                                _editingComment = null;
                                _replyingToCommentId = c.id;
                                _replyingToName = c.author.fullName;
                              });
                            },
                            onLongPress: () => _showCommentOptions(c),
                            showViewReplies: c.replyCount > 0,
                            isExpanded: provider.isExpanded(c.id),
                            loadingReplies: provider.isLoadingReplies(c.id),
                            onViewReplies: () => provider.loadReplies(c),
                            onLike: () => provider.toggleLikeComment(c),
                          ),

                          ...provider.getReplies(c.id).map((reply) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommentItem(
                                  comment: reply,
                                  onReply: () {
                                    setState(() {
                                      _editingComment = null;
                                      _replyingToCommentId = reply.id;
                                      _replyingToName = c.author.fullName;
                                    });
                                  },
                                  onLongPress: () => _showCommentOptions(reply),
                                  showViewReplies: reply.replyCount > 0,
                                  isExpanded: provider.isExpanded(reply.id),
                                  loadingReplies: provider.isLoadingReplies(
                                    reply.id,
                                  ),
                                  onViewReplies: () =>
                                      provider.loadReplies(reply),
                                  onLike: () =>
                                      provider.toggleLikeComment(reply),
                                ),

                                ...provider
                                    .getReplies(reply.id)
                                    .map(
                                      (lv3) => CommentItem(
                                        comment: lv3,
                                        onReply: () {
                                          setState(() {
                                            _editingComment = null;
                                            _replyingToCommentId = lv3.id;
                                            _replyingToName =
                                                lv3.author.fullName;
                                          });
                                        },
                                        onLongPress: () =>
                                            _showCommentOptions(lv3),
                                        onLike: () =>
                                            provider.toggleLikeComment(lv3),
                                      ),
                                    ),
                              ],
                            );
                          }),
                        ],
                      );
                    }).toList(),
                  ),

                  if (provider.loadingComments && provider.comments.isEmpty)
                    const Column(
                      children: [
                        CommentItemSkeleton(),
                        CommentItemSkeleton(level: 2),
                        CommentItemSkeleton(),
                      ],
                    ),
                ],
              ),
            ),

            // COMMENT INPUT
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_replyingToCommentId != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Đang trả lời $_replyingToName",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _replyingToCommentId = null;
                                        _replyingToName = null;
                                      }),
                                      child: const Icon(Icons.close, size: 16),
                                    ),
                                  ],
                                ),
                              ),
                            if (_editingComment != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Đang chỉnh sửa bình luận",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _editingComment = null;
                                        _replyingToCommentId = null;
                                        _replyingToName = null;
                                        _controller.clear();
                                      }),
                                      child: const Icon(Icons.close, size: 16),
                                    ),
                                  ],
                                ),
                              ),
                            TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: _editingComment != null
                                    ? "Chỉnh sửa bình luận..."
                                    : "Viết bình luận...",
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _editingComment != null ? Icons.check : Icons.send,
                        ),
                        onPressed: () async {
                          final text = _controller.text.trim();
                          if (text.isEmpty) return;

                          final provider = context.read<PostDetailProvider>();

                          bool success;

                          if (_editingComment != null) {
                            success = await provider.editComment(
                              commentId: _editingComment!.id,
                              newContent: text,
                            );
                          } else {
                            success = await provider.createComment(
                              content: text,
                              parentId: _replyingToCommentId,
                            );
                          }

                          if (!mounted) return;

                          if (success) {
                            _controller.clear();
                            setState(() {
                              _editingComment = null;
                              _replyingToCommentId = null;
                              _replyingToName = null;
                            });
                            FocusScope.of(context).unfocus();
                          } else {
                            FocusScope.of(context).unfocus();
                            showMsg(
                              context,
                              provider.commentError ?? "Có lỗi xảy ra",
                              false,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildContentWithTags(PostDetailModel post) {
  final tags = post.hashTags
      .map((tag) => tag.startsWith("#") ? tag : "#$tag")
      .join(" ");

  return RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
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
