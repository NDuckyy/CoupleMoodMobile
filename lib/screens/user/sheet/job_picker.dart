import 'package:flutter/material.dart';

class JobPickerField extends StatelessWidget {
  final String? value;
  final List<String> options;
  final Function(String) onChanged;

  const JobPickerField({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        String? tempValue = value;

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height *
                    0.7, // 👈 FIX chiều cao
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    const Text(
                      "Chọn nghề nghiệp",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// 👇 LIST SCROLL
                    Expanded(
                      child: ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final job = options[index];

                          return RadioListTile<String>(
                            value: job,
                            groupValue: tempValue,
                            onChanged: (val) {
                              setState(() => tempValue = val);
                            },
                            title: Text(job),
                          );
                        },
                      ),
                    ),

                    /// BUTTON
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, tempValue);
                          },
                          child: const Text("Xác nhận"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? "Chọn nghề nghiệp",
              style: TextStyle(
                color: value == null ? Colors.grey : Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
