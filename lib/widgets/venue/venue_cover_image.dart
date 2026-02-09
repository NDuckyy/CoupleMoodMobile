import 'package:flutter/material.dart';

class VenueCoverImage extends StatelessWidget {
  final String? imageUrl;

  const VenueCoverImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: imageUrl == null
          ? _placeholder()
          : Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },
              errorBuilder: (_, __, ___) => _placeholder(),
            ),
    );
  }

  Widget _placeholder() {
    return Image.asset(
      'lib/assets/images/venue_placeholder.png',
      fit: BoxFit.cover,
    );
  }
}
