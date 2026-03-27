import 'package:couple_mood_mobile/models/dateplan/date_plan_item_update_request.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/createDatePlanItem/widget/time_picker_section.dart';
import 'package:couple_mood_mobile/widgets/custom_test_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';

class EditDatePlanItemScreen extends StatefulWidget {
  final int datePlanItemId;
  final int datePlanId;

  const EditDatePlanItemScreen({
    super.key,
    required this.datePlanItemId,
    required this.datePlanId,
  });

  @override
  State<EditDatePlanItemScreen> createState() => _EditDatePlanItemScreenState();
}

class _EditDatePlanItemScreenState extends State<EditDatePlanItemScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? startAt;
  DateTime? endAt;

  final TextEditingController orderCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();

  void _initData() async {
    final provider = context.read<DatePlanProvider>();
    await provider.getDatePlanItemDetails(
      widget.datePlanId,
      widget.datePlanItemId,
    );
    final item = provider.selectedDatePlanItem?.data;

    if (item == null) {
      showMsg(context, "Không tìm thấy lịch hẹn", false);
      context.pop();
      return;
    }

    final now = DateTime.now();

    startAt = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(item.startTime.split(":")[0]),
      int.parse(item.startTime.split(":")[1]),
    );

    endAt = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(item.endTime.split(":")[0]),
      int.parse(item.endTime.split(":")[1]),
    );

    orderCtrl.text = item.orderIndex.toString();
    noteCtrl.text = item.note;

    setState(() {});
  }

  String formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}:00";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  @override
  void dispose() {
    orderCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (startAt == null || endAt == null) {
      showMsg(context, "Vui lòng chọn thời gian", false);
      return;
    }

    if (endAt!.isBefore(startAt!)) {
      showMsg(context, "Giờ kết thúc phải sau giờ bắt đầu", false);
      return;
    }

    final provider = context.read<DatePlanProvider>();

    await provider.updateDatePlanItem(
      widget.datePlanId,
      widget.datePlanItemId,
      DatePlanItemUpdateRequest(
        startTime: formatTime(startAt!),
        endTime: formatTime(endAt!),
        note: noteCtrl.text.trim(),
        version: provider.selectedDatePlanItem!.data!.version,
      ),
    );

    if (!mounted) return;

    if (provider.error != null) {
      showMsg(context, provider.error!, false);
    } else {
      showMsg(context, "Cập nhật thành công 💖", true);
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DatePlanProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Chỉnh sửa hoạt động 💕"),
        backgroundColor: Colors.white,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    /// TIME PICKER
                    TimePickerSection(
                      initialStart: startAt,
                      initialEnd: endAt,
                      onStartTimeChanged: (v) => setState(() => startAt = v),
                      onEndTimeChanged: (v) => setState(() => endAt = v),
                    ),

                    const SizedBox(height: 16),

                    /// NOTE
                    CustomTextField(
                      label: 'Ghi chú',
                      hint: 'Nhập ghi chú...',
                      icon: Icons.notes,
                      controller: noteCtrl,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB388EB),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Cập nhật",
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
