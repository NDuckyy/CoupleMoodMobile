import 'dart:math';
import 'package:couple_mood_mobile/widgets/venue/collection_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'flying_heart.dart';
import '../common/rating_stars.dart';
import '../../providers/venue/venue_detail_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';

class VenueTitleRow extends StatefulWidget {
  final String name;
  final double rating;
  final int reviewCount;
  final List<String> categories;

  const VenueTitleRow({
    super.key,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.categories,
  });

  @override
  State<VenueTitleRow> createState() => _VenueTitleRowState();
}

class _VenueTitleRowState extends State<VenueTitleRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  final List<Widget> _flyingHearts = [];
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _scale = TweenSequence(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 35),
        TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.95), weight: 30),
        TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 35),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _glow = Tween(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _playHeartEffect() {
    _controller.forward(from: 0);

    final count = 2 + _rand.nextInt(2);
    for (int i = 0; i < count; i++) {
      final dx = (_rand.nextDouble() * 16) - 8;
      final heart = FlyingHeart(dx: dx);
      _flyingHearts.add(heart);

      Future.delayed(const Duration(milliseconds: 750), () {
        if (mounted) {
          setState(() => _flyingHearts.remove(heart));
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VenueDetailProvider>();
    final isFavorite = provider.isFavorite;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            GestureDetector(
              onTap: provider.favoriteLoading
                  ? null
                  : () async {
                      final success = await provider.toggleFavorite();

                      if (!mounted) return;

                      if (success) {
                        if (success && provider.isFavorite) {
                          await provider.loadCollectionSummaries();

                          final collections = provider.collections;

                          if (collections.length <= 1) {
                            showMsg(
                              context,
                              "❤️ Đã thêm vào Mục yêu thích",
                              true,
                            );
                          } else {
                            _playHeartEffect();

                            showCollectionPicker(
                              context,
                              collections,
                              provider,
                            );
                          }
                        } else {
                          showMsg(context, "Đã xoá khỏi Mục yêu thích", true);
                        }
                      }
                    },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Transform.scale(
                    scale: _scale.value,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        ..._flyingHearts,
                        provider.favoriteLoading
                            ? const SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 28,
                                color: isFavorite ? Colors.pink : Colors.grey,
                                shadows: isFavorite
                                    ? [
                                        Shadow(
                                          color: Colors.pink.withOpacity(0.7),
                                          blurRadius: _glow.value,
                                        ),
                                      ]
                                    : null,
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              widget.rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            RatingStars(rating: widget.rating),
            const SizedBox(width: 6),
            Text(
              '(${widget.reviewCount})',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (widget.categories.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: widget.categories.map((cat) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cat,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
