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
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay(List<dynamic> results, String query) {
    _overlayEntry?.remove();

    // Nếu chưa nhập gì → không show
    if (query.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 55),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: results.isEmpty
                ? ListTile(
                    title: Text(
                      "Không tìm thấy kết quả ",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (_, index) {
                      final item = results[index];
                      final name = item['name'] ?? item.toString();
                      return ListTile(
                        title: Text(name),
                        onTap: () {
                          widget.onSubmitted(name);
                          _controller.text = name;
                          _hideOverlay();
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    if (_overlayEntry?.mounted ?? false) {
      _overlayEntry!.remove();
    }
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _hideOverlay, // click ngoài thì hide overlay
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: CompositedTransformTarget(
          link: _layerLink,
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
                        widget.onSubmitted(value.isEmpty ? "" : value);
                        _hideOverlay();
                      },
                      onChanged: (q) async {
                        final provider = context.read<RecommendationProvider>();
                        await provider.autoComplete(q);

                        if (q.isEmpty) {
                          _hideOverlay();
                        } else {
                          _showOverlay(provider.autoCompleteResult, q);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
