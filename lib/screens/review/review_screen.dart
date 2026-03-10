import 'dart:io';

import 'package:couple_mood_mobile/models/checkin/validate_condition.dart';
import 'package:couple_mood_mobile/models/venue/review_request.dart';
import 'package:couple_mood_mobile/providers/notification_provider.dart';
import 'package:couple_mood_mobile/providers/venue/venue_detail_provider.dart';
import 'package:couple_mood_mobile/providers/venue/venue_review_provider.dart';
import 'package:couple_mood_mobile/screens/review/widget/anonymous_switch.dart';
import 'package:couple_mood_mobile/screens/review/widget/header_card.dart';
import 'package:couple_mood_mobile/screens/review/widget/rating_section.dart';
import 'package:couple_mood_mobile/screens/review/widget/review_content_field.dart';
import 'package:couple_mood_mobile/screens/review/widget/review_image_picker.dart';
import 'package:couple_mood_mobile/screens/review/widget/submit_button.dart';
import 'package:couple_mood_mobile/services/location_service.dart';
import 'package:couple_mood_mobile/utils/upload_util.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  final int venueLocationId;
  final int checkInId;

  const ReviewScreen({
    super.key,
    required this.venueLocationId,
    required this.checkInId,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  int rating = 0;
  bool isAnonymous = false;
  final TextEditingController contentController = TextEditingController();
  List<String> images = [];
  List<String> uploadedImageUrls = [];

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VenueDetailProvider>().loadVenue(widget.venueLocationId);
    });
  }

  void _submitReview() async {
    final reviewProvider = context.read<VenueReviewProvider>();
    final notificationProvider = context.read<NotificationProvider>();
    if (!_formKey.currentState!.validate()) return;
    uploadedImageUrls.clear();
    if (rating == 0) {
      showMsg(context, "Vui lòng chọn số sao đánh giá", false);
      return;
    }

    try {
        final res = await UploadUtil.mediaUpload(images.map((path) => File(path)).toList());
        uploadedImageUrls = res;
    } catch (e) {
      debugPrint("Error uploading image: $e");
    }

    ReviewRequest request = ReviewRequest(
      venueLocationId: widget.venueLocationId,
      checkInId: widget.checkInId,
      content: contentController.text,
      rating: rating,
      isAnonymous: isAnonymous,
      imageUrls: uploadedImageUrls,
    );
    try {
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        if (!mounted) return;
        showMsg(context, "Không thể lấy vị trí hiện tại", false);
        return;
      } else {
        final res = await notificationProvider.validateCheckIn(
          widget.checkInId,
          ValidateCondition(
            venueLocationId: widget.venueLocationId,
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
        if (!res) {
          if (!mounted) return;
          showMsg(context, "Bạn không ở gần địa điểm này để đánh giá", false);
        } else {
          await reviewProvider.submitReview(request);
          if (reviewProvider.error != null) {
            if (!mounted) return;
            showMsg(context, reviewProvider.error!, false);
          }
          if (!mounted) return;
          showMsg(context, "Đánh giá đã được gửi", true);
          context.pop();
        }
      }
    } catch (e) {
      debugPrint("Error submitting review: $e");
      if (!mounted) return;
      showMsg(context, "Gửi đánh giá thất bại", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final venueProvider = context.watch<VenueDetailProvider>();
    final venue = venueProvider.venue;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Đánh giá địa điểm"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderCard(
                  name: venue?.name ?? "Chưa có tên",
                  address: venue?.address ?? "Chưa có địa chỉ",
                  coverImages: venue?.coverImages ?? [],
                  coupleMoodTypes: venue?.coupleMoodTypes ?? [],
                ),
                const SizedBox(height: 20),
                RatingSection(
                  rating: rating,
                  onChanged: (value) {
                    setState(() => rating = value);
                  },
                ),
                const SizedBox(height: 20),
                ReviewContentField(controller: contentController),
                const SizedBox(height: 20),
                ReviewImagePicker(
                  images: images,
                  onChanged: (list) {
                    setState(() => images = list);
                  },
                ),
                const SizedBox(height: 20),
                AnonymousSwitch(
                  value: isAnonymous,
                  onChanged: (val) {
                    setState(() => isAnonymous = val);
                  },
                ),
                const SizedBox(height: 30),
                SubmitButton(onPressed: _submitReview),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
