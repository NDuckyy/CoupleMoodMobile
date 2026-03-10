import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdvertisementPopup extends StatelessWidget {
  final String bannerUrl;
  final VoidCallback? onTap;

  const AdvertisementPopup({
    super.key,
    required this.bannerUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                bannerUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}