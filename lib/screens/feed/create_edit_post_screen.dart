import 'dart:io';
import 'package:couple_mood_mobile/providers/user/user_provider.dart';
import 'package:couple_mood_mobile/widgets/feed/post_composer_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/post/post_model.dart';
import '../../models/post/media_model.dart';
import '../../providers/post/post_provider.dart';
import '../../widgets/feed/post_image_grid.dart';
import '../../widgets/feed/topic_selector.dart';
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

    // Listener để cập nhật số ký tự
    _contentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _contentController.removeListener(() {}); // cleanup
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Cập nhật hàm submit()
  Future<void> submit() async {
    final rawContent = _contentController.text.trim();
    final content = removeHashtags(rawContent);

    // === VALIDATION MỚI ===
    if (content.isEmpty && newImages.isEmpty && oldMedia.isEmpty) {
      showMsg(context, "Bài viết không được để trống", false);
      return;
    }

    if (newImages.isEmpty && oldMedia.isEmpty) {
      showMsg(context, "Phải có ít nhất 1 ảnh", false);
      return;
    }

    if (_contentController.text.length > 500) {
      showMsg(context, "Nội dung tối đa 500 ký tự", false);
      return;
    }

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
      } else if (provider.error != null && mounted) {
        showMsg(context, provider.error!, false);
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e
            .toString()
            .replaceFirst('Exception:', '')
            .replaceFirst('Exception: ', '')
            .trim();
        showMsg(
          context,
          errorMsg.isNotEmpty ? errorMsg : "Có lỗi xảy ra",
          false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 244, 252),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDFDFD),
          elevation: 0.5,
          title: Text(
            isEdit ? "Chỉnh sửa bài viết" : "Tạo bài viết",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton(
              onPressed: loading ? null : submit,
              child: Text(
                isEdit ? "Lưu" : "Đăng bài",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: loading ? Colors.grey : const Color(0xFF8E24AA),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER (avatar + name + visibility)
              if (user != null)
                PostComposerHeader(
                  name: user.fullName ?? "",
                  avatarUrl: user.avatarUrl,
                  visibility: visibility,
                  onVisibilityChanged: (v) {
                    setState(() => visibility = v);
                  },
                ),

              const SizedBox(height: 12),
              // Nội dung + đếm ký tự
              TextField(
                controller: _contentController,
                focusNode: _focusNode,
                maxLines: null,
                minLines: 6,
                maxLength: 500,
                inputFormatters: [LengthLimitingTextInputFormatter(500)],
                decoration: const InputDecoration(
                  hintText: "Bạn đang nghĩ gì?",
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                  counterText: '',
                ),
                style: const TextStyle(fontSize: 17),
              ),

              // Số ký tự
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${_contentController.text.length}/500",
                  style: TextStyle(
                    color: _contentController.text.length > 500
                        ? Colors.red
                        : Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TopicSelector(
                selectedTopics: selectedTopics,
                onToggle: (key) {
                  setState(() {
                    if (selectedTopics.contains(key)) {
                      selectedTopics.remove(key);
                    } else {
                      selectedTopics.add(key);
                    }
                  });
                },
              ),

              const SizedBox(height: 20),

              // Ảnh
              PostImageGrid(
                newImages: newImages,
                oldMedia: oldMedia,
                onRemoveOld: (i) => setState(() => oldMedia.removeAt(i)),
                onRemoveNew: (i) => setState(() => newImages.removeAt(i)),
              ),

              const SizedBox(height: 16),

              // Nút thêm ảnh
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: (newImages.length + oldMedia.length) >= 4
                      ? null
                      : pickImages,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text("Thêm ảnh (tối đa 4)"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF8E24AA)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
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
