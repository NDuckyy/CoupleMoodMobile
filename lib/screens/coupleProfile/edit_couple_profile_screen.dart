import 'package:couple_mood_mobile/models/couple/update_couple_profile_request.dart';
import 'package:couple_mood_mobile/providers/couple_provider.dart';
import 'package:couple_mood_mobile/utils/currency_utils.dart';
import 'package:couple_mood_mobile/widgets/custom_test_field.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditCoupleProfilePage extends StatefulWidget {
  final String? coupleName;
  final String? anniversaryDate;
  final double? budgetMin;
  final double? budgetMax;

  const EditCoupleProfilePage({
    super.key,
    this.coupleName,
    this.anniversaryDate,
    this.budgetMin,
    this.budgetMax,
  });

  @override
  State<EditCoupleProfilePage> createState() => _EditCoupleProfilePageState();
}

class _EditCoupleProfilePageState extends State<EditCoupleProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController budgetMinController = TextEditingController();
  final TextEditingController budgetMaxController = TextEditingController();

  DateTime? anniversaryDate;
  final formatter = DateFormat('dd-MM-yyyy');
  final bodyFormatter = DateFormat('yyyy-MM-dd');
  final maxCurrency = 100000000;

  late CoupleProvider coupleProvider;

  @override
  void initState() {
    super.initState();
    coupleProvider = context.read<CoupleProvider>();
    nameController.text = widget.coupleName ?? "";
    if (widget.anniversaryDate != null) {
      anniversaryDate = DateTime.parse(widget.anniversaryDate!);
    }
    if (widget.budgetMin != null) {
      budgetMinController.text = CurrencyUtils.formatRaw(
        widget.budgetMin!.toInt(),
      );
    }

    if (widget.budgetMax != null) {
      budgetMaxController.text = CurrencyUtils.formatRaw(
        widget.budgetMax!.toInt(),
      );
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        anniversaryDate = picked;
      });
    }
  }

  void handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (budgetMinController.text.isNotEmpty &&
          budgetMaxController.text.isNotEmpty) {
        final min = CurrencyUtils.parseVND(budgetMinController.text);
        final max = CurrencyUtils.parseVND(budgetMaxController.text);

        if (min > maxCurrency || max > maxCurrency) {
          showMsg(
            context,
            "Ngân sách không được vượt quá ${CurrencyUtils.formatVND(maxCurrency)}",
            false,
          );
          return;
        }
      }
      final request = UpdateCoupleProfileRequest(
        coupleName: nameController.text.isEmpty ? null : nameController.text,
        aniversaryDate: anniversaryDate == null
            ? null
            : bodyFormatter.format(anniversaryDate!),
        budgetMin: budgetMinController.text.isEmpty
            ? 0
            : CurrencyUtils.parseVND(budgetMinController.text),

        budgetMax: budgetMaxController.text.isEmpty
            ? 0
            : CurrencyUtils.parseVND(budgetMaxController.text),
      );

      debugPrint("Update body: ${request.toJson()}");
      await coupleProvider.updateCoupleProfile(request);
      if (coupleProvider.error != null) {
        if (!mounted) return;
        showMsg(context, coupleProvider.error!, false);
      } else {
        if (!mounted) return;
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
        title: const Text("Chỉnh sửa", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
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
                          CustomTextField(
                            label: "Tên cặp đôi",
                            hint: "Nhập tên cặp đôi",
                            icon: Icons.favorite,
                            controller: nameController,
                          ),

                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: pickDate,
                            child: AbsorbPointer(
                              child: CustomTextField(
                                label: "Ngày kỷ niệm",
                                hint: "Chọn ngày kỷ niệm",
                                icon: Icons.calendar_today,
                                controller: TextEditingController(
                                  text: anniversaryDate == null
                                      ? ""
                                      : formatter.format(anniversaryDate!),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// Budget
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Tối thiểu",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    TextFormField(
                                      controller: budgetMinController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [VNDInputFormatter()],
                                      validator: (v) {
                                        if (v == null || v.isEmpty) return null;

                                        final amount = CurrencyUtils.parseVND(
                                          v,
                                        );

                                        if (amount < 0) {
                                          return "Sai số";
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "0",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),

                                        prefixText: "đ ",

                                        filled: true,
                                        fillColor: Colors.white,

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFB388EB),
                                            width: 1.2,
                                          ),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF8093F1),
                                            width: 1.6,
                                          ),
                                        ),

                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.redAccent,
                                          ),
                                        ),

                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.redAccent,
                                            width: 1.6,
                                          ),
                                        ),

                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Tối đa",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    TextFormField(
                                      controller: budgetMaxController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [VNDInputFormatter()],
                                      validator: (v) {
                                        if (v == null || v.isEmpty) return null;

                                        final amount = CurrencyUtils.parseVND(
                                          v,
                                        );

                                        if (amount < 0) {
                                          return "Sai số";
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "1000000",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),

                                        prefixText: "đ ",

                                        filled: true,
                                        fillColor: Colors.white,

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFB388EB),
                                            width: 1.2,
                                          ),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF8093F1),
                                            width: 1.6,
                                          ),
                                        ),

                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.redAccent,
                                          ),
                                        ),

                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.redAccent,
                                            width: 1.6,
                                          ),
                                        ),

                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                      ),
                                    ),
                                  ],
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
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
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
