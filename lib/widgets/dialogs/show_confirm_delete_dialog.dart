import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showConfirmDeleteDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
  String title = 'Xóa mục này?',
  String description =
      'Hành động này không thể hoàn tác. Bạn có chắc chắn muốn xóa không?',
  String confirmText = 'Xóa',
  String cancelText = 'Hủy',
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: const [
          Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFF8093F1),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Xác nhận xóa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF8093F1),
              ),
            ),
          ),
        ],
      ),
      content: Text(
        description,
        style: const TextStyle(
          color: Color(0xFFB388EB),
          height: 1.4,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF8093F1),
          ),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            context.pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF7AEF8),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
