import 'package:flutter/material.dart';
import 'package:couple_mood_mobile/models/collection/collection_item.dart';

class CollectionHeader extends StatelessWidget {
  final CollectionItem collection;

  const CollectionHeader({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: collection.img != null && collection.img!.isNotEmpty
              ? Image.network(
                  collection.img!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'lib/assets/images/collection_placeholder.png',
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Image.asset(
                  'lib/assets/images/collection_placeholder.png',
                  fit: BoxFit.cover,
                ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 16,
          child: Row(
            children: [
              const Icon(Icons.place, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                '${collection.venues.length} địa điểm',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
