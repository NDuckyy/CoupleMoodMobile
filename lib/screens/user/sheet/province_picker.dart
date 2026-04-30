import 'package:couple_mood_mobile/models/coupleInvitation/provinces.dart';
import 'package:couple_mood_mobile/providers/user/edit_profile_provider.dart';
import 'package:flutter/material.dart';
import '../widget/box_section.dart';

class ProvincePickerField extends StatelessWidget {
  final String? value;
  final Function(Provinces) onSelected;
  final EditProfileProvider provider;

  const ProvincePickerField({
    super.key,
    required this.value,
    required this.onSelected,
    required this.provider,
  });

  Future<void> _openPicker(BuildContext context) async {
    final TextEditingController searchController = TextEditingController();
    List<Provinces> filtered = provider.provinces ?? [];

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: false, // 🔥 quan trọng
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            void onSearch(String keyword) {
              setState(() {
                filtered = (provider.provinces ?? [])
                    .where(
                      (p) =>
                          p.name.toLowerCase().contains(keyword.toLowerCase()),
                    )
                    .toList();
              });
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6, // 🔥 chỉ 60%
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  /// SEARCH
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearch,
                      decoration: const InputDecoration(
                        hintText: "Tìm tỉnh/thành...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  /// LIST (dùng Flexible thay vì Expanded)
                  Flexible(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final p = filtered[index];
                        return ListTile(
                          title: Text(p.name),
                          onTap: () => Navigator.pop(context, p),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      onSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: boxSection(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value ?? "Chọn tỉnh/thành"),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
