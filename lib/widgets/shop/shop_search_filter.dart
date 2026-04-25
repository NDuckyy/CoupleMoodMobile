import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/providers/shop/shop_provider.dart';

class ShopSearchFilter extends StatefulWidget {
  final bool isInventory; // 👈 thêm

  const ShopSearchFilter({super.key, this.isInventory = false});

  @override
  State<ShopSearchFilter> createState() => _ShopSearchFilterState();
}

class _ShopSearchFilterState extends State<ShopSearchFilter> {
  final TextEditingController _controller = TextEditingController();

  void _triggerFetch(ShopProvider provider) {
    if (widget.isInventory) {
      provider.fetchInventory();
    } else {
      provider.fetchInitial();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ShopProvider>();
      _controller.text = provider.keyword;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          /// 🔍 SEARCH
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              FocusScope.of(context).unfocus();

              final provider = context.read<ShopProvider>();
              provider.updateKeyword(value);

              _triggerFetch(provider); // 👈 FIX
            },
            decoration: InputDecoration(
              hintText: "Tìm phụ kiện...",
              prefixIcon: const Icon(Icons.search),

              /// ❌ CLEAR
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _controller.clear();

                        final provider = context.read<ShopProvider>();
                        provider.updateKeyword('');

                        _triggerFetch(provider); // 👈 FIX

                        setState(() {});
                      },
                    )
                  : null,

              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),

            onChanged: (_) {
              setState(() {});
            },
          ),

          const SizedBox(height: 12),

          /// 🎯 FILTER
          Row(
            children: [
              _buildFilterChip(context, "Tất cả", null),
              const SizedBox(width: 8),
              _buildFilterChip(context, "Khung", "FRAME"),
              const SizedBox(width: 8),
              _buildFilterChip(context, "Huy hiệu", "BADGE"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String? type) {
    final provider = context.watch<ShopProvider>();
    final isSelected = provider.selectedType == type;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        final provider = context.read<ShopProvider>();
        provider.updateType(type);

        _triggerFetch(provider); // 👈 FIX QUAN TRỌNG
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF4E9E) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
