import 'package:flutter/material.dart';

class UserSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const UserSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFFFDC5F5), Color(0xFFF7AEF8)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFB388EB).withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF8093F1)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  cursorColor: Color(0xFFB388EB),
                  decoration: const InputDecoration(
                    hintText: "Tìm kiếm bạn bè 💕",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    onSearch(value.isEmpty ? "" : value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
