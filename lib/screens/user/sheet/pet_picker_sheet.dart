import 'package:couple_mood_mobile/providers/user/edit_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<List<String>?> openPetPicker({
  required BuildContext context,
  required List<String> favoritePets,
}) {
  final provider = context.read<EditProfileProvider>();

  List<String> tempSelected = List.from(favoritePets);

  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final options = provider.animals ?? [];

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
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

                const Text(
                  "Chọn thú cưng",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: ListView(
                    children: options.map((item) {
                      final selected = tempSelected.contains(item);

                      return CheckboxListTile(
                        value: selected,
                        title: Text(item),
                        onChanged: (v) {
                          setModalState(() {
                            if (selected) {
                              tempSelected.remove(item);
                            } else {
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
                      backgroundColor: const Color(0xFF8093F1),
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
