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

  String formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}:00";
  }

  Future<void> _submit() async {
    final datePlanProvider = context.read<DatePlanProvider>();
    if (_formKey.currentState!.validate()) {
      List<ItemRequest> items = [];
      items.add(
        ItemRequest(
          venueLocationId: venueLocationId,
          note: noteCtrl.text.trim(),
          startTime: startTime != null ? formatTime(startTime!) : '',
          endTime: endTime != null ? formatTime(endTime!) : '',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        final result = await context.pushNamed(
                          'choose_location',
                        );
                        if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            locationName = result['venueName'] ?? '';
                            venueLocationId = result['venueLocationId'] ?? -1;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFDC5F5).withOpacity(0.4),
                              const Color(0xFFF7AEF8).withOpacity(0.4),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB388EB).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.location_on_rounded,
                                size: 18,
                                color: Color(0xFFB388EB),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                locationName.isEmpty
                                    ? 'Chọn địa điểm hẹn hò 💕'
                                    : locationName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: locationName.isEmpty
                                      ? Colors.black87
                                      : Colors.black87,
                                ),
                              ),
                            ),

                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFB388EB).withOpacity(0.15),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final result = await context.pushNamed(
                          'choose_location',
                        );
                        if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            locationName = result['venueName'] ?? '';
                            venueLocationId = result['venueLocationId'] ?? -1;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                        color: Color(0xFFB388EB),
                      ),
                    ),
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
