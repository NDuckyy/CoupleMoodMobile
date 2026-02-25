import 'package:flutter/material.dart';
import '../../models/post/media_model.dart';

class PostMedia extends StatelessWidget {
  final List<MediaModel> mediaList;

  const PostMedia({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: mediaList.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(mediaList[index].url, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
