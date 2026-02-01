import 'package:couple_mood_mobile/widgets/venue/venue_info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/currency_utils.dart';
import '../../providers/venue_detail_provider.dart';
import '../../widgets/venue/venue_cover_image.dart';
import '../../widgets/venue/venue_basic_info.dart';

class VenueDetailScreen extends StatefulWidget {
  final int venueId;

  const VenueDetailScreen({super.key, required this.venueId});

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VenueDetailProvider>().loadVenue(widget.venueId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VenueDetailProvider>();

    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final venue = provider.venue;
    if (venue == null) {
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy địa điểm')),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VenueCoverImage(imageUrl: venue.coverImage),
            VenueBasicInfo(venue: venue),
            VenueInfoCard(
              title: 'ĐỊA CHỈ',
              expandable: true,
              previewAlignment: CrossAxisAlignment.start,
              expandedAlignment: CrossAxisAlignment.start,
              previewContent: Text(venue.address),
              expandedContent: venue.venueOwner == null
                  ? const Text('Không có thông tin liên hệ')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tên chủ địa điểm: ' + venue.venueOwner!.businessName,
                        ),
                        Text('Số điện thoại: ' + venue.venueOwner!.phoneNumber),
                        Text('Email: ' + venue.venueOwner!.email),
                      ],
                    ),
            ),

            VenueInfoCard(
              title: 'THỜI GIAN',
              expandable: true,
              previewAlignment: CrossAxisAlignment.center,
              expandedAlignment: CrossAxisAlignment.start,
              previewContent: Text(
                venue.todayOpeningHour ?? 'Chưa xác định',
                style: TextStyle(
                  color: venue.todayOpeningHour != null
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
              expandedContent: Text(venue.openingHours ?? 'Chưa có thông tin'),
            ),

            VenueInfoCard(
              title: 'GIÁ CẢ',
              previewAlignment: CrossAxisAlignment.start,
              previewContent: Text(
                CurrencyUtils.formatRangeVND(venue.priceMin, venue.priceMax),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
