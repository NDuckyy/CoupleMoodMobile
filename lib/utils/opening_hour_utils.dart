import 'package:flutter/material.dart';
import '../models/venue/today_opening_hour.dart';

class OpeningHourUtils {
  static Color statusColor(TodayOpeningHour? hour) {
    if (hour == null || hour.status.isEmpty) return Colors.grey;

    final status = hour.status.toLowerCase();

    if (status.contains('đã đóng')) {
      return Colors.red;
    } else if (status.contains('đang mở')) {
      return Colors.green;
    }

    return Colors.grey;
  }

  static String statusText(TodayOpeningHour? hour) {
    if (hour == null || hour.status.isEmpty) {
      return 'Chưa xác định';
    }

    return hour.status; // ✅ dùng trực tiếp BE
  }

  static String timeRange(TodayOpeningHour? hour) {
    if (hour == null) return '';

    String format(String time) {
      return time.length >= 5 ? time.substring(0, 5) : time;
    }

    return '${format(hour.openTime)} – ${format(hour.closeTime)}';
  }
}
