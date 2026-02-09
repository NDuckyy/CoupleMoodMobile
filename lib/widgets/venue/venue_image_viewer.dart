import 'package:flutter/material.dart';

class VenueImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const VenueImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<VenueImageViewer> createState() => _VenueImageViewerState();
}

class _VenueImageViewerState extends State<VenueImageViewer> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    widget.images[index],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const CircularProgressIndicator();
                    },
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              );
            },
          ),

          /// Close button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          /// Index indicator
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  '${_currentIndex + 1}/${widget.images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
