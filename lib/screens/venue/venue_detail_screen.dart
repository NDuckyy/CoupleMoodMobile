import 'package:couple_mood_mobile/widgets/venue/venue_info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/currency_utils.dart';
import '../../utils/opening_hour_utils.dart';
import '../../providers/venue_detail_provider.dart';
import '../../widgets/venue/venue_cover_skeleton.dart';
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

    final String? coverImage = venue.coverImages.isNotEmpty
        ? venue.coverImages.first
        : null;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// COVER + BACK BUTTON
            /// COVER + BACK BUTTON
            Stack(
              children: [
                if (provider.loading)
                  const VenueCoverSkeleton()
                else
                  VenueCoverImage(imageUrl: coverImage),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            VenueBasicInfo(venue: venue),

            /// ĐỊA CHỈ
            VenueInfoCard(
              title: 'ĐỊA CHỈ',
              expandable: true,
              previewAlignment: CrossAxisAlignment.start,
              expandedAlignment: CrossAxisAlignment.start,
              previewContent: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 20,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(venue.address)),
                ],
              ),
              expandedContent: venue.venueOwner == null
                  ? const Text('Không có thông tin liên hệ')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.store,
                              size: 18,
                              color: Colors.indigo,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(venue.venueOwner!.businessName),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 18,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text(venue.venueOwner!.phoneNumber),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.email,
                              size: 18,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(venue.venueOwner!.email)),
                          ],
                        ),
                      ],
                    ),
            ),

            /// THỜI GIAN
            VenueInfoCard(
              title: 'THỜI GIAN',
              previewAlignment: CrossAxisAlignment.start,
              previewContent: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.access_time_filled,
                    size: 20,
                    color: OpeningHourUtils.statusColor(venue.todayOpeningHour),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        OpeningHourUtils.statusText(venue.todayOpeningHour),
                        style: TextStyle(
                          color: OpeningHourUtils.statusColor(
                            venue.todayOpeningHour,
                          ),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (OpeningHourUtils.timeRange(
                        venue.todayOpeningHour,
                      ).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            OpeningHourUtils.timeRange(venue.todayOpeningHour),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            /// GIÁ CẢ
            VenueInfoCard(
              title: 'GIÁ CẢ',
              previewAlignment: CrossAxisAlignment.start,
              previewContent: Row(
                children: [
                  const Icon(Icons.payments, size: 20, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    CurrencyUtils.formatRangeVND(
                      venue.priceMin,
                      venue.priceMax,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
