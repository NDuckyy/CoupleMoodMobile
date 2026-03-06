import 'dart:io';
import 'package:couple_mood_mobile/widgets/feed/hashtag_input.dart';
import 'package:couple_mood_mobile/widgets/feed/post_image_grid.dart';
import 'package:couple_mood_mobile/widgets/feed/topic_selector.dart';
import 'package:couple_mood_mobile/widgets/feed/visibility_selector.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/post/post_model.dart';
import '../../models/post/media_model.dart';
import '../../providers/post/post_provider.dart';

class CreateEditPostScreen extends StatefulWidget {
  final PostModel? post;

  const CreateEditPostScreen({super.key, this.post});

  @override
  State<CreateEditPostScreen> createState() => _CreateEditPostScreenState();
}

class _CreateEditPostScreenState extends State<CreateEditPostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _hashtagController = TextEditingController();

  List<String> selectedTopics = [];
  String visibility = "PUBLIC";

  List<File> newImages = [];
  List<MediaModel> oldMedia = [];

  bool loading = false;

  bool get isEdit => widget.post != null;

  @override
  void initState() {
    super.initState();

    context.read<PostProvider>().loadTopics();

    if (isEdit) {
      _contentController.text = widget.post!.content;
      oldMedia = List.from(widget.post!.mediaPayload);
      selectedTopics = List.from(widget.post!.topic);

      _hashtagController.text = widget.post!.hashTags
          .map((e) => "#$e")
          .join(" ");
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();

    if (files.isEmpty) return;

    /// tổng số ảnh hiện tại
    final currentTotal = newImages.length + oldMedia.length;

    /// số ảnh còn được phép chọn
    final remaining = 4 - currentTotal;

    if (remaining <= 0) {
      showMsg(context, "Chỉ được tối đa 4 ảnh", false);
      return;
    }

    /// nếu user chọn nhiều hơn số cho phép
    final selected = files.take(remaining);

    setState(() {
      newImages.addAll(selected.map((e) => File(e.path)));
    });

    if (files.length > remaining) {
      showMsg(context, "Chỉ được tối đa 4 ảnh", false);
    }
  }

  Future<void> submit() async {
    final content = _contentController.text.trim();

    if (content.isEmpty && newImages.isEmpty && oldMedia.isEmpty) {
      showMsg(context, "Post cannot be empty", false);
      return;
    }

    final hashTags = _hashtagController.text.trim().isEmpty
        ? null
        : _hashtagController.text
              .split(" ")
              .where((e) => e.trim().isNotEmpty)
              .map((e) => e.replaceAll("#", ""))
              .toList();

    setState(() => loading = true);

    try {
      final provider = context.read<PostProvider>();

      bool success;

      if (isEdit) {
        success = await provider.updatePost(
          postId: widget.post!.id,
          content: content,
          newMediaFiles: newImages,
          oldMedia: oldMedia,
          visibility: visibility,
          hashTags: hashTags,
          topic: selectedTopics,
        );
      } else {
        success = await provider.createPost(
          content: content,
          mediaFiles: newImages,
          visibility: visibility,
          hashTags: hashTags,
          topic: selectedTopics,
        );
      }

      if (success && mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      showMsg(context, e.toString(), false);
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Chỉnh sửa bài viết" : "Tạo bài viết"),
        actions: [
          TextButton(
            onPressed: loading ? null : submit,
            child: Text(isEdit ? "Save" : "Post"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Bạn đang nghĩ gì?",
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 16),

            VisibilitySelector(
              value: visibility,
              onChanged: (v) => setState(() => visibility = v),
            ),

            const SizedBox(height: 16),

            HashtagInput(controller: _hashtagController),

            const SizedBox(height: 16),

            TopicSelector(
              selectedTopics: selectedTopics,
              onToggle: (topicKey) {
                setState(() {
                  if (selectedTopics.contains(topicKey)) {
                    selectedTopics.remove(topicKey);
                  } else {
                    selectedTopics.add(topicKey);
                  }
                });
              },
            ),

            const SizedBox(height: 16),

            PostImageGrid(
              newImages: newImages,
              oldMedia: oldMedia,
              onRemoveOld: (i) => setState(() => oldMedia.removeAt(i)),
              onRemoveNew: (i) => setState(() => newImages.removeAt(i)),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: (newImages.length + oldMedia.length) >= 4
                  ? null
                  : pickImages,
              icon: const Icon(Icons.image),
              label: const Text("Add Ảnh (tối đa 4 ảnh)"),
            ),
          ],
        ),
      ),
    );
  }
}
