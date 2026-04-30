import 'package:couple_mood_mobile/models/coupleInvitation/communes.dart';
import 'package:couple_mood_mobile/providers/user/edit_profile_provider.dart';
import 'package:flutter/material.dart';
import '../widget/box_section.dart';

class CommunePickerField extends StatelessWidget {
  final String? value;
  final String? provinceCode;
  final Function(Communes) onSelected;
  final EditProfileProvider provider;

  const CommunePickerField({
    super.key,
    required this.value,
    required this.onSelected,
    required this.provider,
    required this.provinceCode,
  });

  Future<void> _openPicker(BuildContext context) async {
    if (provinceCode == null) return;

    final TextEditingController searchController = TextEditingController();

    List<Communes> baseList = provider.communes ?? [];
    List<Communes> filtered = baseList;

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            void onSearch(String keyword) {
              setState(() {
                filtered = baseList
                    .where(
                      (c) =>
                          c.name.toLowerCase().contains(keyword.toLowerCase()),
                    )
                    .toList();
              });
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
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
                        hintText: "Tìm quận/huyện...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  /// LIST
                  Flexible(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final c = filtered[index];
                        return ListTile(
                          title: Text(c.name),
                          onTap: () => Navigator.pop(context, c),
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
      onTap: provinceCode == null ? null : () => _openPicker(context),
      child: boxSection(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              provinceCode == null
                  ? "Chọn tỉnh trước"
                  : (value ??
                        (provider.communes == null
                            ? "Đang tải..."
                            : "Chọn quận/huyện")),
            ),
            provider.communes == null
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
