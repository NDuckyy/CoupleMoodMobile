import 'package:flutter/material.dart';

class UserSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const UserSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  void _handleSearch() {
    onSearch(controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFB388EB),
            Color(0xFF8093F1),
          ],
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controller,

          onSubmitted: (_) => _handleSearch(),

          textInputAction: TextInputAction.search,

          decoration: InputDecoration(
            hintText: "Tìm kiếm theo tên",

            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _handleSearch,
            ),

            // Clear
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.clear();
                    },
                  )
                : null,

            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
    );
  }
}
