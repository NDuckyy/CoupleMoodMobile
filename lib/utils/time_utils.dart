import 'package:intl/intl.dart';

String timeAgo(DateTime dateTime) {
  final difference = DateTime.now().difference(dateTime);

  if (difference.inMinutes < 1) return "Vừa xong";
  if (difference.inMinutes < 60) return "${difference.inMinutes} phút trước";
  if (difference.inHours < 24) return "${difference.inHours} giờ trước";
  return "${difference.inDays} ngày trước";
}

//  FORMAT DATE VN
String formatDateVN(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

//  FORMAT DATE + TIME VN
String formatDateTimeVN(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}
