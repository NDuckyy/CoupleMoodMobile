import 'package:flutter/material.dart';

class VenueCoverImage extends StatelessWidget {
  final String? imageUrl;

  const VenueCoverImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(imageUrl!, fit: BoxFit.cover)
          : Image.asset(
              'lib/assets/images/venue_placeholder.png',
              fit: BoxFit.cover,
            ),
    );
  }
}
