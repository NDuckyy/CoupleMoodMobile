import 'package:flutter/material.dart';
import 'collection_action_button.dart';

class CollectionActionRow extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CollectionActionRow({
    super.key,
    required this.onShare,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CollectionActionButton(
            icon: Icons.edit,
            label: 'Chỉnh sửa',
            color: Colors.orange,
            onTap: onEdit,
          ),
          const SizedBox(width: 12),
          CollectionActionButton(
            icon: Icons.share,
            label: 'Chia sẻ',
            color: Colors.pinkAccent,
            onTap: onShare,
          ),
          const SizedBox(width: 12),
          CollectionActionButton(
            icon: Icons.delete,
            label: 'Xóa',
            color: Colors.red,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
