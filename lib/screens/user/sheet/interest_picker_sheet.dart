import 'package:couple_mood_mobile/providers/user/edit_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<List<String>?> openInterestPicker({
  required BuildContext context,
  required List<String> interests,
}) {
  final provider = context.read<EditProfileProvider>();

  List<String> tempSelected = List.from(interests);

  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final options = (provider.interests ?? [])
              .map((e) => e.name)
              .whereType<String>()
              .toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Text(
                  "Chọn sở thích (${tempSelected.length}/5)",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: ListView(
                    children: options.map((item) {
                      final selected = tempSelected.contains(item);

                      return CheckboxListTile(
                        value: selected,
                        title: Text(item),
                        activeColor: const Color(0xFFB388EB),
                        onChanged: (v) {
                          setModalState(() {
                            if (selected) {
                              tempSelected.remove(item);
                            } else {
                              if (tempSelected.length >= 5) return;
                              tempSelected.add(item);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, tempSelected);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: const Color(0xFFB388EB),
                    ),
                    child: const Text("Xác nhận"),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
