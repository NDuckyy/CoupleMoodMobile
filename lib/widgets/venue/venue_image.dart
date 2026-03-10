import 'package:flutter/material.dart';

class VenueImage extends StatelessWidget {
  final String? imageUrl;

  const VenueImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Image.asset(
        "lib/assets/images/collection_placeholder.png",
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      imageUrl!,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Image.asset(
          "lib/assets/images/collection_placeholder.png",
          fit: BoxFit.cover,
        );
      },
    );
  }
}
