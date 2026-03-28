import 'package:couple_mood_mobile/models/notification/notification.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final NotificationApp notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread ? Color(0xFFB388EB).withOpacity(0.3) : Color(0xFFF1F1F1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildIcon(notification.type),
          SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  _formatTime(notification.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),

          /// DOT
          if (isUnread)
            Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: Color(0xFFB388EB),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData icon;

    switch (type) {
      case "CHAT":
        icon = Icons.chat_bubble_outline;
        break;
      case "CHECKIN":
        icon = Icons.location_on_outlined;
        break;
      case "LOVE":
        icon = Icons.favorite_border;
        break;
      default:
        icon = Icons.notifications_none;
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFF8093F1).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Color(0xFF8093F1),
        size: 20,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}