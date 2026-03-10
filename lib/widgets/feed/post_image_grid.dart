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
    if (total == 0) return const SizedBox();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: total,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final isOld = index < oldMedia.length;

        Widget image;

        if (isOld) {
          image = Image.network(oldMedia[index].url, fit: BoxFit.cover);
        } else {
          image = Image.file(
            newImages[index - oldMedia.length],
            fit: BoxFit.cover,
          );
        }

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox.expand(child: image),
            ),

            /// REMOVE BUTTON
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  if (isOld) {
                    onRemoveOld(index);
                  } else {
                    onRemoveNew(index - oldMedia.length);
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
