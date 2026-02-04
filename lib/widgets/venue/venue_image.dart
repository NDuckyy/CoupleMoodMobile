import 'package:flutter/material.dart';

class VenueImage extends StatelessWidget {
  final String? imageUrl;

  const VenueImage({required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return SizedBox(
      height: 150,
      width: double.infinity,
      child: (url == null || url.isEmpty)
          ? Container(
              color: Colors.black12,
              child: const Center(
                child: Icon(Icons.image_not_supported_outlined),
              ),
            )
          : Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stack) {
                return Container(
                  color: Colors.black12,
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined),
                  ),
                );
              },
            ),
    );
  }
}
