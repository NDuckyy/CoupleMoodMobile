import 'dart:async';

import 'package:couple_mood_mobile/models/mood/mood_type.dart';
import 'package:flutter/material.dart';

class MoodCarousel extends StatefulWidget {
  final List<MoodType> moods;
  final Function(MoodType) onSelect;

  const MoodCarousel({super.key, required this.moods, required this.onSelect});

  @override
  State<MoodCarousel> createState() => _MoodCarouselState();
}

class _MoodCarouselState extends State<MoodCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.45);
  int currentIndex = 0;
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.moods.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 150), () {
            widget.onSelect(widget.moods[index]);
          });
        },
        itemBuilder: (context, index) {
          final MoodType mood = widget.moods[index];
          final isSelected = index == currentIndex;

          return Center(
            key: ValueKey(mood.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.zero,
              transform: Matrix4.identity()..scale(isSelected ? 1.15 : 0.9),
              child: GestureDetector(
                onTap: () {
                  _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  widget.onSelect(mood);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFFB388EB),
                                width: 3,
                              )
                            : null,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          mood.iconUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 70),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      mood.name,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFF8093F1)
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
