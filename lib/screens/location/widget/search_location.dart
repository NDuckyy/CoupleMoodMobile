import 'package:flutter/material.dart';

class SearchLocation extends StatelessWidget {
  final Function(String) onSubmitted;

  const SearchLocation({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

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
                  controller: _controller,
                  cursorColor: Color(0xFFB388EB),
                  decoration: const InputDecoration(
                    hintText: "Tìm kiếm địa điểm hẹn hò 💕",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    onSubmitted(value.isEmpty ? "" : value);
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
