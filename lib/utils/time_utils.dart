String timeAgo(DateTime dateTime) {
  final difference = DateTime.now().difference(dateTime);

  if (difference.inMinutes < 1) return "Vừa xong";
  if (difference.inMinutes < 60) return "${difference.inMinutes} phút trước";
  if (difference.inHours < 24) return "${difference.inHours} giờ trước";
  return "${difference.inDays} ngày trước";
}
