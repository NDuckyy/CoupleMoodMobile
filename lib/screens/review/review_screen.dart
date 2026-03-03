import 'dart:io';

import 'package:couple_mood_mobile/models/venue/review_request.dart';
import 'package:couple_mood_mobile/providers/venue/venue_detail_provider.dart';
import 'package:couple_mood_mobile/screens/review/widget/anonymous_switch.dart';
import 'package:couple_mood_mobile/screens/review/widget/header_card.dart';
import 'package:couple_mood_mobile/screens/review/widget/rating_section.dart';
import 'package:couple_mood_mobile/screens/review/widget/review_content_field.dart';
import 'package:couple_mood_mobile/screens/review/widget/review_image_picker.dart';
import 'package:couple_mood_mobile/screens/review/widget/submit_button.dart';
import 'package:couple_mood_mobile/utils/upload_util.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
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
    if (!_formKey.currentState!.validate()) return;
    uploadedImageUrls.clear();
    if (rating == 0) {
      showMsg(context, "Vui lòng chọn số sao đánh giá", false);
      return;
    }

    try {
      for (var imagePath in images) {
        final res = await UploadUtil.uploadImage(File(imagePath));
        uploadedImageUrls.add(res);
      }
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

    debugPrint("Request body: ${request.toJson()}");
    // TODO: call API
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
