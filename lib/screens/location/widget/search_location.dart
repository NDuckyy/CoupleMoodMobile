import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchLocation extends StatefulWidget {
  final Function(String) onSubmitted;

  const SearchLocation({super.key, required this.onSubmitted});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context, List<dynamic> results) {
    _overlayEntry?.remove(); // Xóa overlay cũ nếu có
    if (results.isEmpty) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (_, index) {
              final item = results[index];
              // Giả sử mỗi item có field 'name'
              final name = item['name'] ?? item.toString();
              return ListTile(
                title: Text(name),
                onTap: () {
                  widget.onSubmitted(name);
                  _controller.text = name;
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                },
              );
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecommendationProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Container(
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
                        widget.onSubmitted(value.isEmpty ? "" : value);
                      },
                      onChanged: (q) {
                        provider.autoComplete(q);
                        // Hiển thị kết quả autocomplete
                        _showOverlay(context, provider.autoCompleteResult);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (provider.isAutoCompleteLoading)
            const LinearProgressIndicator(),
        ],
      ),
    );
  }
}