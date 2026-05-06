import 'package:intl/intl.dart';

String formatBudget(double? min, double? max) {
  final formatter = NumberFormat("#,###", "vi_VN");

  String format(double value) {
    return "${formatter.format(value)}đ";
  }

  if (min != null && max != null) {
    return "${format(min)} - ${format(max)}";
  }
  if (min != null) {
    return "Từ ${format(min)}";
  }
  if (max != null) {
    return "Tối đa ${format(max)}";
  }
  return "Chưa xác định";
}

String formatLocation(String? city, String? district) {
  if (city == null && district == null) return "Không rõ";
  if (city != null && district != null) return "$district, $city";
  return city ?? district!;
}
