import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReviewImagePicker extends StatefulWidget {
  final List<String> images;
  final Function(List<String>) onChanged;

  const ReviewImagePicker({
    super.key,
    required this.images,
    required this.onChanged,
  });

  @override
  State<ReviewImagePicker> createState() => _ReviewImagePickerState();
}

class _ReviewImagePickerState extends State<ReviewImagePicker> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (widget.images.length >= 3) return;

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final updatedList = List<String>.from(widget.images)
        ..add(pickedFile.path);

      widget.onChanged(updatedList);
    }
  }

  void _removeImage(int index) {
    final updatedList = List<String>.from(widget.images)
      ..removeAt(index);

    widget.onChanged(updatedList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thêm ảnh (tối đa 3)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            ...List.generate(widget.images.length, (index) {
              return Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(
                        image: FileImage(File(widget.images[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () => _removeImage(index),
                    ),
                  ),
                ],
              );
            }),
            if (widget.images.length < 3)
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
}