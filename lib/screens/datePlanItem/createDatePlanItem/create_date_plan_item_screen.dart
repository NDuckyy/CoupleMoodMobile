import 'package:couple_mood_mobile/models/dateplan/date_plan_item_request.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/createDatePlanItem/widget/time_picker_section.dart';
import 'package:couple_mood_mobile/widgets/custom_test_field.dart';
import 'package:couple_mood_mobile/widgets/datePlan/submit_button.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateDatePlanItemScreen extends StatefulWidget {
  final int datePlanId;

  const CreateDatePlanItemScreen({super.key, required this.datePlanId});

  @override
  State<CreateDatePlanItemScreen> createState() =>
      _CreateDatePlanItemScreenState();
}

class _CreateDatePlanItemScreenState extends State<CreateDatePlanItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController noteCtrl = TextEditingController();

  DateTime? startTime;
  DateTime? endTime;
  String locationName = '';
  int venueLocationId = -1;

  String formatTime(String isoString) {
    final dateTime = DateTime.parse(isoString);
    return "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}:"
        "${dateTime.second.toString().padLeft(2, '0')}";
  }

  Future<void> _submit() async {
    final datePlanProvider = context.read<DatePlanProvider>();
    if (_formKey.currentState!.validate()) {
      List<ItemRequest> items = [];
      items.add(
        ItemRequest(
          venueLocationId: venueLocationId,
          note: noteCtrl.text.trim(),
          startTime: startTime != null
              ? formatTime(startTime!.toUtc().toIso8601String())
              : '',
          endTime: endTime != null
              ? formatTime(endTime!.toUtc().toIso8601String())
              : '',
        ),
      );
      if (venueLocationId == -1) {
        showMsg(context, "Vui lòng chọn địa điểm", false);
        return;
      }

      if (startTime == null || endTime == null) {
        showMsg(context, "Vui lòng chọn thời gian bắt đầu và kết thúc", false);
        return;
      }
      final request = DatePlanItemRequest(items: items);

      await datePlanProvider.createDatePlanItem(widget.datePlanId, request);

      if (datePlanProvider.error != null) {
        if (!mounted) return;
        showMsg(context, datePlanProvider.error!, false);
      } else {
        if (!mounted) return;
        context.pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tạo mục lịch hẹn hò'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.pinkAccent),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              locationName.isEmpty
                                  ? 'Chọn địa điểm'
                                  : locationName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await context.pushNamed('choose_location');
                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          locationName = result['venueName'] ?? '';
                          venueLocationId = result['venueLocationId'] ?? -1;
                        });
                      }
                    },
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TimePickerSection(
                onStartTimeChanged: (dateTime) {
                  startTime = dateTime;
                },
                onEndTimeChanged: (dateTime) {
                  endTime = dateTime;
                },
              ),
              SizedBox(height: 24),

              CustomTextField(
                label: 'Ghi chú',
                hint: "Nhập ghi chú",
                icon: Icons.note,
                controller: noteCtrl,
                maxLines: 3,
              ),
              SizedBox(height: 32),
              SubmitButton(onPressed: _submit, label: "Xác nhận"),
            ],
          ),
        ),
      ),
    );
  }
}
