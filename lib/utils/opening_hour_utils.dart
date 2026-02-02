import 'package:flutter/material.dart';
import '../models/today_opening_hour.dart';

class OpeningHourUtils {
  static Color statusColor(TodayOpeningHour? hour) {
    if (hour == null) return Colors.grey;
    return hour.isClosed ? Colors.red : Colors.green;
  }

  static String statusText(TodayOpeningHour? hour) {
    if (hour == null) return 'Chưa xác định';
    return hour.isClosed ? 'Đã đóng cửa' : 'Đang mở cửa';
  }

  static String timeRange(TodayOpeningHour? hour) {
    if (hour == null) return '';
    return '${hour.openTime} – ${hour.closeTime}';
  }
}
