import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/venue/venue_detail_provider.dart';
import '../../utils/number_utils.dart';

class VenueFavoriteInfo extends StatelessWidget {
  const VenueFavoriteInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<VenueDetailProvider>().favoriteCount;

    return Row(
      children: [
        const Icon(Icons.favorite, size: 16, color: Colors.redAccent),
        const SizedBox(width: 4),
        Text(
          count > 0
              ? '${formatCount(count)} người yêu thích địa điểm này'
              : 'Chưa có người yêu thích địa điểm này',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
