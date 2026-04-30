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
    final result = await showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: provider.provinces?.map((p) {
                return ListTile(
                  title: Text(p.name),
                  onTap: () => Navigator.pop(context, p),
                );
              }).toList() ??
              [],
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