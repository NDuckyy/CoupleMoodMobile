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
    String query = "";

    final result = await showModalBottomSheet<Provinces>(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final baseList = provider.provinces ?? [];

            final filtered = baseList
                .where(
                  (p) => p.name.toLowerCase().contains(query.toLowerCase()),
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
                    "Chọn tỉnh/thành",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  /// SEARCH đẹp (chuẩn picker)
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
