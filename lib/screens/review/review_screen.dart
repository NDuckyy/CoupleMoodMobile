import 'package:couple_mood_mobile/models/venue/venue_review.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/review/review_provider.dart';
import '../../providers/venue/venue_detail_provider.dart';

import '../../widgets/snack_bar.dart';

import 'widget/anonymous_switch.dart';
import 'widget/header_card.dart';
import 'widget/rating_section.dart';
import 'widget/review_content_field.dart';
import 'widget/review_image_picker.dart';

class ReviewScreen extends StatefulWidget {
  final int venueLocationId;
  final int? checkInId;
  final VenueReview? initialReview;

  const ReviewScreen({
    super.key,
    required this.venueLocationId,
    this.checkInId,
    this.initialReview,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  int rating = 0;
  bool isAnonymous = false;
  final TextEditingController contentController = TextEditingController();
  List<String> oldImages = [];
  List<String> newImages = [];

  late final bool isEditMode;

  @override
  void initState() {
    super.initState();

    isEditMode = widget.initialReview != null;

    /// chỉ load data để render UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VenueDetailProvider>().loadVenue(widget.venueLocationId);
    });

    final review = widget.initialReview;
    if (review != null) {
      rating = review.rating;
      isAnonymous = review.isAnonymous;
      contentController.text = review.content;

      /// ảnh cũ là URL
      oldImages = List<String>.from(review.imageUrls);
    }
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ReviewProvider>();

    final isEditMode = widget.initialReview != null;

    bool success = false;

    if (isEditMode) {
      ///  UPDATE
      success = await provider.updateReview(
        reviewId: widget.initialReview!.id,
        venueLocationId: widget.venueLocationId,
        rating: rating,
        content: contentController.text.trim(),
        isAnonymous: isAnonymous,

        /// ảnh gốc từ BE
        originalImages: widget.initialReview!.imageUrls,

        /// ảnh cũ sau khi user xóa bớt
        currentOldImages: oldImages,

        /// ảnh mới user thêm
        newLocalImages: newImages,
      );
    } else {
      if (widget.checkInId == null) {
        showMsg(context, "Thiếu check-in", false);
        return;
      }

      ///  CREATE
      success = await provider.submitReview(
        venueLocationId: widget.venueLocationId,
        checkInId: widget.checkInId!,
        rating: rating,
        content: contentController.text.trim(),
        isAnonymous: isAnonymous,
        localImagePaths: newImages,
      );
    }

    if (!mounted) return;

    if (success) {
      showMsg(
        context,
        isEditMode ? "Cập nhật đánh giá thành công" : "Đánh giá đã được gửi",
        true,
      );
      context.pop(true); // trả result về để refresh list
    } else {
      showMsg(context, provider.error ?? "Có lỗi xảy ra", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final venueProvider = context.watch<VenueDetailProvider>();
    final reviewProvider = context.watch<ReviewProvider>();

    final venue = venueProvider.venue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditMode ? "Chỉnh sửa đánh giá" : "Đánh giá địa điểm"),
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
                /// HEADER
                HeaderCard(
                  name: venue?.name ?? "Chưa có tên",
                  address: venue?.address ?? "Chưa có địa chỉ",
                  coverImages: venue?.coverImages ?? [],
                  coupleMoodTypes: venue?.coupleMoodTypes ?? [],
                ),

                const SizedBox(height: 20),

                /// RATING
                RatingSection(
                  rating: rating,
                  onChanged: (value) {
                    setState(() => rating = value);
                  },
                ),

                const SizedBox(height: 20),

                /// CONTENT
                ReviewContentField(controller: contentController),

                const SizedBox(height: 20),

                /// IMAGES
                ReviewImagePicker(
                  oldImages: oldImages,
                  newImages: newImages,
                  onOldRemoved: (url) {
                    setState(() => oldImages.remove(url));
                  },
                  onNewChanged: (list) {
                    setState(() => newImages = list);
                  },
                ),

                const SizedBox(height: 20),

                /// ANONYMOUS
                AnonymousSwitch(
                  value: isAnonymous,
                  onChanged: (val) {
                    setState(() => isAnonymous = val);
                  },
                ),

                const SizedBox(height: 30),

                /// SUBMIT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: reviewProvider.isLoading ? null : _submitReview,
                    child: reviewProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEditMode ? "Cập nhật" : "Gửi đánh giá"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
