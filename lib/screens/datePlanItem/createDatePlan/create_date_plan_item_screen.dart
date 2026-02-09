import 'package:couple_mood_mobile/screens/datePlanItem/createDatePlan/widget/time_picker_section.dart';
import 'package:couple_mood_mobile/widgets/custom_test_field.dart';
import 'package:couple_mood_mobile/widgets/datePlan/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateDatePlanItemScreen extends StatefulWidget {
  const CreateDatePlanItemScreen({super.key});

  @override
  State<CreateDatePlanItemScreen> createState() =>
      _CreateDatePlanItemScreenState();
}

class _CreateDatePlanItemScreenState extends State<CreateDatePlanItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController noteCtrl = TextEditingController();

  DateTime? startTime;
  DateTime? endTime;

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
                          Text(
                            'Địa điểm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await context.pushNamed(
                        'choose_location',
                      );
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
              SubmitButton(onPressed: () => {}, label: "Xác nhận"),
            ],
          ),
        ),
      ),
    );
  }
}
