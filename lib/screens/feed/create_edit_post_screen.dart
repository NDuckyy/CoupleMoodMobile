import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/post/post_model.dart';
import '../../models/post/media_model.dart';
import '../../providers/post/post_provider.dart';
import '../../widgets/feed/post_image_grid.dart';
import '../../widgets/feed/topic_selector.dart';
import '../../widgets/feed/visibility_selector.dart';
import '../../widgets/snack_bar.dart';

class CreateEditPostScreen extends StatefulWidget {
  final PostModel? post;

  const CreateEditPostScreen({super.key, this.post});

  @override
  State<CreateEditPostScreen> createState() => _CreateEditPostScreenState();
}

class _CreateEditPostScreenState extends State<CreateEditPostScreen> {
  final HashtagTextController _contentController = HashtagTextController();
  final FocusNode _focusNode = FocusNode();

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
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();

    if (files.isEmpty) return;

    final currentTotal = newImages.length + oldMedia.length;
    final remaining = 4 - currentTotal;

    if (remaining <= 0) {
      showMsg(context, "Chỉ được tối đa 4 ảnh", false);
      return;
    }

    final selected = files.take(remaining);

    setState(() {
      newImages.addAll(selected.map((e) => File(e.path)));
    });

    if (files.length > remaining) {
      showMsg(context, "Chỉ được tối đa 4 ảnh", false);
    }
  }

  Future<void> submit() async {
    final rawContent = _contentController.text.trim();
    final content = removeHashtags(rawContent);

    if (content.isEmpty && newImages.isEmpty && oldMedia.isEmpty) {
      showMsg(context, "Post cannot be empty", false);
      return;
    }

    /// 🔥 extract hashtag từ content
    final hashTags = _contentController.extractHashtags();

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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      /// 👇 tap ra ngoài để đóng keyboard
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _contentController,
                focusNode: _focusNode,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                autofocus: true,
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
      ),
    );
  }
}

class HashtagTextController extends TextEditingController {
  /// hỗ trợ cả tiếng Việt
  final RegExp hashtagRegex = RegExp(r'(?<=\s|^)#[\p{L}0-9_]+', unicode: true);

  List<String> extractHashtags() {
    return hashtagRegex
        .allMatches(text)
        .map((e) => e.group(0)!.replaceAll("#", "").toLowerCase())
        .toSet()
        .toList();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final children = <TextSpan>[];
    final matches = hashtagRegex.allMatches(text);

    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        children.add(
          TextSpan(text: text.substring(lastIndex, match.start), style: style),
        );
      }

      children.add(
        TextSpan(
          text: match.group(0),
          style: style?.copyWith(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      children.add(TextSpan(text: text.substring(lastIndex), style: style));
    }

    return TextSpan(style: style, children: children);
  }
}

String removeHashtags(String text) {
  final regex = RegExp(r'(?<=\s|^)#[\p{L}0-9_]+', unicode: true);

  return text
      .replaceAll(regex, '') // xóa hashtag
      .replaceAll(RegExp(r'\s+'), ' ') // fix double space
      .trim();
}
