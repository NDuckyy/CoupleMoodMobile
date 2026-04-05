import 'package:couple_mood_mobile/models/notification/notification.dart';
import 'package:couple_mood_mobile/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NotificationItem extends StatelessWidget {
  final NotificationApp notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isUnread
            ? const Color(0xFFB388EB).withOpacity(0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread
              ? const Color(0xFFB388EB)
              : const Color(0xFFF1F1F1),
          width: isUnread ? 1.2 : 1,
        ),
        boxShadow: [
          if (isUnread)
            BoxShadow(
              color: const Color(0xFFB388EB).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: const Color(0xFFB388EB).withOpacity(0.1),
          highlightColor: const Color(0xFFB388EB).withOpacity(0.05),
          onTap: () => _handleTap(context),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _buildIcon(notification.type, isUnread),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: isUnread
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 15,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isUnread
                              ? const Color(0xFF444444)
                              : const Color(0xFF666666),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatTime(notification.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),

                if (isUnread)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFB388EB),
                          Color(0xFF8093F1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Mới",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    final notiProvider = context.read<NotificationProvider>();

    if (!notification.isRead) {
      notiProvider.markAsRead(notification.id);
    }

    switch (notification.type) {
      case "PAIRING":
        context.goNamed('datePlan');
        break;

      case "LOCATION":
        context.pushNamed(
          'review_venue',
          extra: {
            "venueLocationId":
                int.tryParse(notification.data?.venueLocationId ?? "0") ?? 0,
            "checkInId": notification.referenceId,
          },
        );
        break;

      case "MAP":
        context.goNamed('map');
        break;

      case "SYSTEM":
        _showDialog(context);
        break;

      default:
        break;
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFDC5F5),
                Color(0xFFF7AEF8),
                Color(0xFFB388EB),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                notification.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                notification.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFB388EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Đóng",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(String type, bool isUnread) {
    IconData icon;

    switch (type) {
      case "CHAT":
        icon = Icons.chat_bubble_outline;
        break;
      case "LOCATION":
        icon = Icons.location_on_outlined;
        break;
      case "SYSTEM":
        icon = Icons.favorite_border;
        break;
      case "PAIRING":
        icon = Icons.favorite;
        break;
      default:
        icon = Icons.notifications_none;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isUnread
            ? const Color(0xFFB388EB).withOpacity(0.15)
            : const Color(0xFF8093F1).withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isUnread
            ? const Color(0xFFB388EB)
            : const Color(0xFF8093F1),
        size: 20,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}