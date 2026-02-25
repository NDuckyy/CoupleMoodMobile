import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekSelector extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const WeekSelector({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<WeekSelector> createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  late DateTime selectedDate;
  late DateTime baseDate;
  late ScrollController _scrollController;

  final double itemWidth = 72;
  final double horizontalMargin = 6;

  double get fullItemWidth => itemWidth + horizontalMargin * 2;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    baseDate = widget.initialDate;
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerSelected();
    });
  }

  // Generate days
  List<DateTime> _generateDays() {
    final startOfWeek = baseDate.subtract(Duration(days: baseDate.weekday - 1));

    return List.generate(30, (index) => startOfWeek.add(Duration(days: index)));
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Center selected
  void _centerSelected() {
    if (!_scrollController.hasClients) return;

    final days = _generateDays();

    final index = days.indexWhere((d) => _isSameDate(d, selectedDate));

    if (index == -1) return;

    final screenWidth = MediaQuery.of(context).size.width;

    final offset =
        (index * fullItemWidth) - (screenWidth / 2) + (fullItemWidth / 2);

    final maxScroll = _scrollController.position.maxScrollExtent;

    _scrollController.animateTo(
      offset.clamp(0, maxScroll),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  // Today logic
  bool get _isTodaySelected {
    return _isSameDate(selectedDate, DateTime.now());
  }

  void _goToToday() {
    final now = DateTime.now();

    setState(() {
      selectedDate = now;
    });

    widget.onDateSelected(now);
    _centerSelected();
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateDays();

    final text = DateFormat('MMMM yyyy', 'vi').format(selectedDate);
    final capitalized = text[0].toUpperCase() + text.substring(1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            capitalized,
            key: ValueKey(selectedDate.month),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// Week Scroll
        Stack(
          children: [
            SizedBox(
              height: 95,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final date = days[index];
                  final isSelected = _isSameDate(date, selectedDate);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });

                      widget.onDateSelected(date);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _centerSelected();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: itemWidth,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFDC5F5).withOpacity(0.35)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 250),
                        scale: isSelected ? 1.12 : 1.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? const Color(0xFFB388EB)
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('EEE', 'vi').format(date),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? const Color(0xFFB388EB)
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (!_isTodaySelected)
              Positioned(
                right: 16,
                bottom: 0,
                child: GestureDetector(
                  onTap: _goToToday,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF7AEF8), Color(0xFFB388EB)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Text(
                      "Hôm nay",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
