String formatBudget(double? min, double? max) {
  if (min != null && max != null) {
    return "${min.toInt()}k - ${max.toInt()}k";
  }
  if (min != null) {
    return "Từ ${min.toInt()}k";
  }
  if (max != null) {
    return "Tối đa ${max.toInt()}k";
  }
  return "Không rõ";
}

String formatLocation(String? city, String? district) {
  if (city == null && district == null) return "Không rõ";
  if (city != null && district != null) return "$district, $city";
  return city ?? district!;
}