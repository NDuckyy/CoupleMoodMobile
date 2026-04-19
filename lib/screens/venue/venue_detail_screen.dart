import 'package:couple_mood_mobile/models/report/report_target_type.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:couple_mood_mobile/widgets/report/report_bottom_sheet.dart';
import 'package:couple_mood_mobile/widgets/venue/venue_info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';

import '../../utils/currency_utils.dart';
import '../../utils/opening_hour_utils.dart';
import '../../providers/venue/venue_detail_provider.dart';
import '../../providers/venue/venue_review_provider.dart';
import '../../widgets/venue/venue_cover_skeleton.dart';
import '../../widgets/venue/venue_cover_image.dart';
import '../../widgets/venue/venue_basic_info.dart';
import '../../widgets/venue/venue_image_slider.dart';
import '../../widgets/venue/venue_review_section.dart';

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

  Future<void> _handleCheckIn() async {
    final provider = context.read<VenueDetailProvider>();
    final venue = provider.venue;

    if (venue == null) return;

    final (success, message) = await provider.handleCheckInFlow(venue.id);

    if (!mounted) return;

    if (success) {
      showMsg(
        context,
        message ?? (success ? "Check-in thành công" : "Check-in thất bại"),
        success,
      );
    } else {
      showMsg(context, provider.checkInError ?? "Check-in thất bại", false);
    }
  }

  Widget _buildCheckInButton(VenueDetailProvider provider) {
    final isLoading = provider.checkInLoading;
    final isDisabled = provider.isCheckInDisabled;
    final disabledText = provider.checkInDisabledMessage;

    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : _handleCheckIn,
      child: AnimatedScale(
        scale: isLoading ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: (isLoading || isDisabled)
                  ? [Colors.grey.shade400, Colors.grey.shade600]
                  : [const Color(0xFFFF1E7E), const Color(0xFF9C27FF)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              if (!isLoading)
                BoxShadow(
                  color: const Color(0xFFFF1E7E).withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              splashColor: Colors.white.withOpacity(0.22),
              highlightColor: Colors.white.withOpacity(0.15),
              onTap: (isLoading || isDisabled) ? null : _handleCheckIn,
              child: Center(
                child: Center(
                  child: isLoading
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.8,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 14),
                            Text(
                              "Đang check-in...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isDisabled
                                  ? Icons.lock_rounded
                                  : Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              isDisabled
                                  ? (disabledText ?? "Không thể check-in")
                                  : "Check-in ngay",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

    final List<String> venueImages = [
      ...venue.interiorImages,
      ...venue.fullPageMenuImages,
    ];

    return ChangeNotifierProvider(
      create: (_) =>
          VenueReviewProvider()..loadPage(venueId: venue.id, page: 1),
      child: Scaffold(
        body: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// COVER, BACK + REPORT BUTTON
                Stack(
                  children: [
                    if (provider.loading)
                      const VenueCoverSkeleton()
                    else
                      VenueCoverImage(imageUrl: coverImage),

                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _circleButton(
                              icon: Icons.arrow_back_ios_new,
                              onTap: () => Navigator.pop(context),
                            ),

                            /// REPORT BUTTON
                            _circleButton(
                              icon: Icons.flag,
                              onTap: () {
                                showReportBottomSheet(
                                  context: context,
                                  targetId: venue.id,
                                  targetType: ReportTargetType.venue,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                VenueBasicInfo(venue: venue),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _buildCheckInButton(provider),
                ),

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
                        color: OpeningHourUtils.statusColor(
                          venue.todayOpeningHour,
                        ),
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
                                OpeningHourUtils.timeRange(
                                  venue.todayOpeningHour,
                                ),
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
                  previewContent: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.payments,
                            size: 20,
                            color: Colors.green,
                          ),
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
                      if (venue.averageCost > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 28, top: 4),
                          child: Text(
                            'Giá trung bình: ${CurrencyUtils.formatVND(venue.averageCost)} / người',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                /// ẢNH ĐỊA ĐIỂM
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    'Ảnh địa điểm',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                VenueImageSlider(images: venueImages),
                const SizedBox(height: 24),

                VenueReviewSection(venueId: venue.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
  return InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    ),
  );
}
