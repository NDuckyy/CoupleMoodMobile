import 'dart:async';

import 'package:couple_mood_mobile/models/recommendation/search_history.dart';
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
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() async {
      final provider = context.read<RecommendationProvider>();

      if (_focusNode.hasFocus) {
        await provider.fetchSearchHistory();
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }

  void _showOverlay() {
    final provider = context.read<RecommendationProvider>();

    if (_overlayEntry?.mounted ?? false) {
      _overlayEntry!.remove();
    }

    _overlayEntry = null;

    final isTyping = _controller.text.isNotEmpty;

    final data = isTyping
        ? provider.autoCompleteResult
        : provider.searchHistory;

    if (data.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _focusNode.unfocus();
                _hideOverlay();
              },
              child: const SizedBox(),
            ),
          ),

          Positioned(
            width: MediaQuery.of(context).size.width - 32,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(0, 55),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: data.length,
                    itemBuilder: (_, index) {
                      if (isTyping) {
                        final item = data[index];
                        final name = item['name'] ?? "";

                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.location_on,
                            color: Color(0xFF8093F1),
                          ),
                          title: Text(name),
                          onTap: () {
                            _controller.text = name;
                            widget.onSubmitted(name);
                            _hideOverlay();
                            _focusNode.unfocus();
                          },
                        );
                      } else {
                        final item = data[index] as SearchHistoryItem;

                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.history,
                            color: Colors.grey,
                          ),
                          title: Text(item.keyword),
                          onTap: () {
                            _controller.text = item.keyword;
                            widget.onSubmitted(item.keyword);
                            _hideOverlay();
                            _focusNode.unfocus();
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    if (!mounted) return;
    final overlay = Overlay.of(context);
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    if (_overlayEntry?.mounted ?? false) {
      _overlayEntry!.remove();
    }
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                color: const Color(0xFFB388EB).withOpacity(0.25),
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
                    focusNode: _focusNode,
                    cursorColor: const Color(0xFFB388EB),
                    decoration: const InputDecoration(
                      hintText: "Tìm kiếm địa điểm hẹn hò 💕",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      widget.onSubmitted(value);
                      _hideOverlay();
                    },
                    onChanged: (q) {
                      setState(() {});
                      if (_debounce?.isActive ?? false) _debounce!.cancel();

                      _debounce = Timer(
                        const Duration(milliseconds: 300),
                        () async {
                          final provider = context
                              .read<RecommendationProvider>();

                          if (q.isEmpty) {
                            await provider.fetchSearchHistory();
                          } else {
                            await provider.autoComplete(q);
                          }

                          if (!mounted) return;
                          _showOverlay();
                        },
                      );
                    },
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () async {
                      _controller.clear();

                      final provider = context.read<RecommendationProvider>();
                      await provider.fetchSearchHistory();

                      if (!mounted) return;
                      _showOverlay();
                      setState(() {}); // update UI
                    },
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
