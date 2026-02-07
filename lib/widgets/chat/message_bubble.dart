import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/chat/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool showAvatar;
  final bool isGroupChat;
  final VoidCallback? onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    required this.showAvatar,
    required this.isGroupChat,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: showAvatar ? 8 : 2,
        bottom: 2,
      ),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar (for group chat, other users only)
          if (!message.isMine && isGroupChat)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: showAvatar
                  ? CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: message.senderAvatar != null
                          ? NetworkImage(message.senderAvatar!)
                          : null,
                      child: message.senderAvatar == null
                          ? Text(
                              message.senderName[0].toUpperCase(),
                              style: const TextStyle(fontSize: 12),
                            )
                          : null,
                    )
                  : const SizedBox(width: 32),
            ),

          // Message bubble
          Flexible(
            child: GestureDetector(
              onLongPress: onDelete != null
                  ? () => _showMessageOptions(context)
                  : null,
              child: Column(
                crossAxisAlignment: message.isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Sender name (for group chat, other users only)
                  if (!message.isMine && isGroupChat && showAvatar)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 4),
                      child: Text(
                        message.senderName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  // Message content
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: message.isMine
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(
                          message.isMine || !showAvatar ? 20 : 4,
                        ),
                        bottomRight: Radius.circular(
                          !message.isMine || !showAvatar ? 20 : 4,
                        ),
                      ),
                    ),
                    child: _buildMessageContent(),
                  ),

                  // Timestamp and status
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 12, right: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(message.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (message.isMine) ...[
                          const SizedBox(width: 4),
                          _buildStatusIcon(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.messageType) {
      case 'TEXT':
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 15,
            color: message.isMine ? Colors.white : Colors.black87,
          ),
        );

      case 'IMAGE':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                message.content,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 48),
                  );
                },
              ),
            ),
            if (message.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  message.content,
                  style: TextStyle(
                    fontSize: 15,
                    color: message.isMine ? Colors.white : Colors.black87,
                  ),
                ),
              ),
          ],
        );

      case 'DATE_PLAN':
        return _buildDatePlanCard();

      case 'LOCATION':
        return _buildLocationCard();

      default:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 15,
            color: message.isMine ? Colors.white : Colors.black87,
          ),
        );
    }
  }

  Widget _buildDatePlanCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message.isMine ? Colors.white.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 20,
                color: message.isMine ? Colors.white : Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                'Date Plan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: message.isMine ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message.content,
            style: TextStyle(
              fontSize: 15,
              color: message.isMine ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to view details',
            style: TextStyle(
              fontSize: 12,
              color: message.isMine ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message.isMine ? Colors.white.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20,
                color: message.isMine ? Colors.white : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: message.isMine ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message.content,
            style: TextStyle(
              fontSize: 15,
              color: message.isMine ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to open in maps',
            style: TextStyle(
              fontSize: 12,
              color: message.isMine ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 14,
          color: Colors.grey[600],
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: 14,
          color: Colors.grey[600],
        );
      case MessageStatus.read:
        return const Icon(
          Icons.done_all,
          size: 14,
          color: Colors.blue,
        );
      case MessageStatus.failed:
        return const Icon(
          Icons.error_outline,
          size: 14,
          color: Colors.red,
        );
    }
  }

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Message',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
