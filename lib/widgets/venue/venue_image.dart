import 'package:flutter/material.dart';

class VenueImage extends StatelessWidget {
  final String? imageUrl;

  const VenueImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        height: 180,
        color: const Color(0xFFF5F5F7),
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: Colors.black26,
          ),
        ),
      );
    }

    return Image.network(
      imageUrl!,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          height: 180,
          color: const Color(0xFFF5F5F7),
          child: const Icon(
            Icons.broken_image_outlined,
            size: 40,
            color: Colors.black26,
          ),
        );
      },
    );
  }
}
