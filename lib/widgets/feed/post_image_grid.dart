import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/post/media_model.dart';

class PostImageGrid extends StatelessWidget {
  final List<File> newImages;
  final List<MediaModel> oldMedia;
  final Function(int) onRemoveOld;
  final Function(int) onRemoveNew;

  const PostImageGrid({
    super.key,
    required this.newImages,
    required this.oldMedia,
    required this.onRemoveOld,
    required this.onRemoveNew,
  });

  int get total => newImages.length + oldMedia.length;

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Ảnh đã chọn",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              "$total/4",
              style: TextStyle(
                color: total >= 4 ? Colors.red : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: total,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final isOld = index < oldMedia.length;
            final imageIndex = isOld ? index : index - oldMedia.length;

            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox.expand(
                    child: isOld
                        ? Image.network(oldMedia[index].url, fit: BoxFit.cover)
                        : Image.file(newImages[imageIndex], fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      if (isOld)
                        onRemoveOld(index);
                      else
                        onRemoveNew(imageIndex);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
