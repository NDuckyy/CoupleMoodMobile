import 'package:intl/intl.dart';

String timeAgo(DateTime dateTime) {
  final local = dateTime.isUtc ? dateTime.toLocal() : dateTime;
  final difference = DateTime.now().difference(local);

  if (difference.inMinutes < 1) return "Vừa xong";
  if (difference.inMinutes < 60) return "${difference.inMinutes} phút trước";
  if (difference.inHours < 24) return "${difference.inHours} giờ trước";
  return "${difference.inDays} ngày trước";
}

String formatDateVN(DateTime dateTime) {
  final local = dateTime.isUtc ? dateTime.toLocal() : dateTime;
  return DateFormat('dd/MM/yyyy').format(local);
}

String formatDateTimeVN(DateTime dateTime) {
  final local = dateTime.isUtc ? dateTime.toLocal() : dateTime;
  return DateFormat('dd/MM/yyyy HH:mm').format(local);
}
