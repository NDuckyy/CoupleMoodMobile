import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReviewImagePicker extends StatefulWidget {
  final List<String> oldImages; // URL
  final List<String> newImages; // local path

  final Function(String url) onOldRemoved;
  final Function(List<String>) onNewChanged;

  const ReviewImagePicker({
    super.key,
    required this.oldImages,
    required this.newImages,
    required this.onOldRemoved,
    required this.onNewChanged,
  });

  @override
  State<ReviewImagePicker> createState() => _ReviewImagePickerState();
}

class _ReviewImagePickerState extends State<ReviewImagePicker> {
  final ImagePicker _picker = ImagePicker();

  int get totalImages => widget.oldImages.length + widget.newImages.length;

  Future<void> _pickImage() async {
    if (totalImages >= 3) return;

    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      final remaining = 3 - totalImages;

      final selected = pickedFiles.take(remaining).map((e) => e.path).toList();

      final updated = [...widget.newImages, ...selected];

      widget.onNewChanged(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Thêm ảnh (tối đa 3)"),
        const SizedBox(height: 10),

        Wrap(
          spacing: 10,
          children: [
            /// OLD IMAGES (URL)
            ...widget.oldImages.map((url) {
              return Stack(
                children: [
                  _buildImage(NetworkImage(url)),
                  _removeBtn(() => widget.onOldRemoved(url)),
                ],
              );
            }),

            /// NEW IMAGES (FILE)
            ...widget.newImages.map((path) {
              return Stack(
                children: [
                  _buildImage(FileImage(File(path))),
                  _removeBtn(() {
                    final updated = List<String>.from(widget.newImages)
                      ..remove(path);
                    widget.onNewChanged(updated);
                  }),
                ],
              );
            }),

            /// ADD BUTTON
            if (totalImages < 3)
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildImage(ImageProvider provider) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(image: provider, fit: BoxFit.cover),
      ),
    );
  }

  Widget _removeBtn(VoidCallback onTap) {
    return Positioned(
      top: -8,
      right: -8,
      child: IconButton(
        icon: const Icon(Icons.cancel, color: Colors.red, size: 20),
        onPressed: onTap,
      ),
    );
  }
}
