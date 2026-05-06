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

    String query = "";

    final result = await showModalBottomSheet<Communes>(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final baseList = provider.communes ?? [];

            final filtered = baseList
                .where(
                  (c) => c.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  /// handle bar
                  Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Chọn Phường",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  /// SEARCH đẹp (đồng bộ toàn app)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      onChanged: (v) => setState(() => query = v),
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final c = filtered[index];

                        final isSelected = value == c.name;

                        return ListTile(
                          title: Text(c.name),

                          /// highlight item đã chọn
                          tileColor: isSelected
                              ? Colors.deepPurple.shade50
                              : null,

                          trailing: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.deepPurple,
                                )
                              : null,

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
                            : "Chọn phường")),
            ),
            provider.communes == null
                ? const Icon(Icons.arrow_forward_ios, size: 16)
                : const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
