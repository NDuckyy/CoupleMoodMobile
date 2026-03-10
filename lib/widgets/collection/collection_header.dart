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

        /// Status badge
        Positioned(
          top: 16,
          right: 16,
          child: _HeaderStatusBadge(status: collection.status),
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

class _HeaderStatusBadge extends StatelessWidget {
  final String status;

  const _HeaderStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPublic = status.toUpperCase() == "PUBLIC";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPublic ? Icons.public : Icons.lock,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            isPublic ? "Công khai" : "Chỉ mình tôi",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
