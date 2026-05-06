import 'package:couple_mood_mobile/models/challenge/streak_model.dart';
import 'package:couple_mood_mobile/models/dateplan/date_plan_calender.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class WeekSelector extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;
  final List<DatePlanDay> calendarDays;
  final List<DayStreak> streakDays;

  const WeekSelector({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    required this.calendarDays,
    required this.streakDays,
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

  DayStreak? _getStreakForDate(DateTime date) {
    for (final d in widget.streakDays) {
      if (d.date == null) continue;
      final dDate = DateTime.parse(d.date!);
      if (_isSameDate(dDate, date)) return d;
    }
    return null;
  }

  //Gen ra 30 ngày bắt đầu 3 ngày trc
  List<DateTime> _generateDays() {
    final startDate = baseDate.subtract(const Duration(days: 3));

    return List.generate(30, (index) => startDate.add(Duration(days: index)));
  }

  DatePlanDay? _getPlanForDate(DateTime date) {
    for (final d in widget.calendarDays) {
      final dDate = DateTime.parse(d.date);
      if (_isSameDate(dDate, date)) return d;
    }
    return null;
  }

  // Check xem nó có cùng ngày hôm nay ko
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  final plan = _getPlanForDate(date);
                  final hasPlan = plan?.hasDatePlan ?? false;
                  final streak = _getStreakForDate(date);
                  final hasCheckedIn = streak?.hasCheckedIn ?? false;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });

                      widget.onDateSelected(date);
                      debugPrint("Selected date: $date, has plan: $hasPlan");
                      if (hasPlan &&
                          plan != null &&
                          plan.datePlanIds.isNotEmpty) {
                        debugPrint("Go to date plan ${plan.datePlanIds.first}");
                        context.pushNamed(
                          "date_plan_item",
                          extra: {
                            "datePlanId": plan.datePlanIds.first,
                            'status': 'PENDING',
                          },
                        );
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _centerSelected();
                      });
                    },
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: itemWidth,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFDC5F5).withOpacity(0.35)
                                : hasPlan
                                ? const Color(0xFF72DDF7).withOpacity(0.15)
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

                        /// ICON
                        if (hasPlan)
                          Positioned(
                            top: 6,
                            right: 10,
                            child: Icon(
                              Icons.favorite,
                              size: 14,
                              color: Colors.pinkAccent,
                            ),
                          ),

                        
                        if (hasCheckedIn) ...[
                          Positioned(
                            top: 6,
                            left: 10,
                            child: Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: Colors.orange,
                            ),
                          ),
                        ] else ...[
                           Positioned(
                            top: 6,
                            left: 10,
                            child: Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ]
                      ],
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
