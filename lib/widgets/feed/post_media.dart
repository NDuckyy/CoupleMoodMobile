import 'package:flutter/material.dart';
import '../../models/post/media_model.dart';

class PostMedia extends StatefulWidget {
  final List<MediaModel> mediaList;

  const PostMedia({super.key, required this.mediaList});

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  void _openGallery(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GalleryScreen(mediaList: widget.mediaList, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaList.isEmpty) return const SizedBox();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openGallery(currentIndex),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SizedBox(
              height: 260,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.mediaList.length,
                onPageChanged: (i) {
                  setState(() {
                    currentIndex = i;
                  });
                },
                itemBuilder: (context, index) {
                  final media = widget.mediaList[index];

                  return Image.network(
                    media.url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;

                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                },
              ),
            ),

            /// IMAGE COUNT
            if (widget.mediaList.length > 1)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${currentIndex + 1}/${widget.mediaList.length}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),

            /// DOT INDICATOR
            if (widget.mediaList.length > 1)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.mediaList.length, (index) {
                    final active = index == currentIndex;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 8 : 6,
                      height: active ? 8 : 6,
                      decoration: BoxDecoration(
                        color: active ? Colors.white : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  final List<MediaModel> mediaList;
  final int initialIndex;

  const GalleryScreen({
    super.key,
    required this.mediaList,
    required this.initialIndex,
  });

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late PageController controller;
  late int current;

  final TransformationController _zoomController = TransformationController();

  @override
  void initState() {
    super.initState();

    current = widget.initialIndex;
    controller = PageController(initialPage: current);
  }

  void _doubleTapZoom() {
    if (_zoomController.value != Matrix4.identity()) {
      _zoomController.value = Matrix4.identity();
    } else {
      _zoomController.value = Matrix4.identity()..scale(2.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "${current + 1}/${widget.mediaList.length}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: widget.mediaList.length,
        onPageChanged: (i) {
          setState(() {
            current = i;
            _zoomController.value = Matrix4.identity();
          });
        },
        itemBuilder: (_, index) {
          final media = widget.mediaList[index];

          return GestureDetector(
            onDoubleTap: _doubleTapZoom,
            child: InteractiveViewer(
              transformationController: _zoomController,
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Image.network(media.url, fit: BoxFit.contain),
              ),
            ),
          );
        },
      ),
    );
  }
}
