import 'package:couple_mood_mobile/models/couple/update_couple_profile_request.dart';
import 'package:couple_mood_mobile/providers/couple_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditCoupleProfilePage extends StatefulWidget {
  const EditCoupleProfilePage({super.key});

  @override
  State<EditCoupleProfilePage> createState() => _EditCoupleProfilePageState();
}

class _EditCoupleProfilePageState extends State<EditCoupleProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController budgetMinController = TextEditingController();
  final TextEditingController budgetMaxController = TextEditingController();

  DateTime? startDate;
  DateTime? anniversaryDate;
  final formatter = DateFormat('yyyy-MM-dd');

  late CoupleProvider coupleProvider;

  @override
  void initState() {
    super.initState();
    coupleProvider = context.read<CoupleProvider>();
  }

  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          anniversaryDate = picked;
        }
      });
    }
  }

  void handleSave() {
    if (!_formKey.currentState!.validate()) return;

    try {
      final request = UpdateCoupleProfileRequest(
        coupleName: nameController.text.isEmpty ? null : nameController.text,
        startDate: formatter.format(startDate ?? DateTime.now()),
        aniversaryDate: formatter.format(anniversaryDate ?? DateTime.now()),
        budgetMin: budgetMinController.text.isEmpty
            ? null
            : int.tryParse(budgetMinController.text),
        budgetMax: budgetMaxController.text.isEmpty
            ? null
            : int.tryParse(budgetMaxController.text),
      );

      debugPrint("Update body: ${request.toJson()}");
      coupleProvider.updateCoupleProfile(request);
      if (coupleProvider.error != null) {
        showMsg(context, coupleProvider.error!, false);
      } else {
        showMsg(context, "Cập nhật thành công", true);
        context.pop();
      }
    } catch (e) {
      showMsg(context, 'Lỗi khi cập nhật thông tin cặp đôi: $e', false);
      debugPrint('Error in handleSave: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text("Chỉnh sửa"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8093F1), Color(0xFFB388EB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  /// 🔥 Card form
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          /// Couple Name
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Tên cặp đôi",
                            ),
                            validator: (v) =>
                                v!.isEmpty ? "Không được để trống" : null,
                          ),

                          const SizedBox(height: 16),

                          /// Start Date
                          ListTile(
                            title: Text(
                              startDate == null
                                  ? "Chọn ngày bắt đầu"
                                  : startDate.toString().split(" ")[0],
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () => pickDate(true),
                          ),

                          /// Anniversary
                          ListTile(
                            title: Text(
                              anniversaryDate == null
                                  ? "Chọn ngày kỷ niệm"
                                  : anniversaryDate.toString().split(" ")[0],
                            ),
                            trailing: const Icon(Icons.favorite),
                            onTap: () => pickDate(false),
                          ),

                          const SizedBox(height: 16),

                          /// Budget
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: budgetMinController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Min",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: budgetMaxController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Max",
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          /// Button Save
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: handleSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8093F1),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                "Lưu thay đổi",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
