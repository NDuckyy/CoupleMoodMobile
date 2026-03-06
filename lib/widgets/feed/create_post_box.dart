import 'package:flutter/material.dart';
import '../../utils/session_storage.dart';
import '../../utils/text_utils.dart';

class CreatePostBox extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onAvatarTap;

  const CreatePostBox({super.key, this.onTap, this.onAvatarTap});

  @override
  State<CreatePostBox> createState() => _CreatePostBoxState();
}

class _CreatePostBoxState extends State<CreatePostBox> {
  String? avatar;
  String? firstName;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final session = await SessionStorage.load();
    setState(() {
      avatar = session?.avatarUrl;
      firstName = getVietnameseFirstName(session?.fullName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onAvatarTap,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              backgroundImage: avatar != null && avatar!.isNotEmpty
                  ? NetworkImage(avatar!)
                  : null,
              child: avatar == null || avatar!.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey[200],
                ),
                child: Text(
                  firstName != null
                      ? "$firstName ơi, bạn đang nghĩ gì?"
                      : "Bạn đang nghĩ gì?",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
