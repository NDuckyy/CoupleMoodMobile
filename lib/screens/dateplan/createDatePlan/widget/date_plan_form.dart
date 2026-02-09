import 'package:couple_mood_mobile/models/dateplan/date_plan_create_request.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/widgets/budget_input.dart';
import 'package:couple_mood_mobile/screens/dateplan/createDatePlan/widget/date_time_picker_section.dart';
import 'package:couple_mood_mobile/widgets/note_input.dart';
import 'package:couple_mood_mobile/widgets/submit_button.dart';
import 'package:couple_mood_mobile/widgets/title_input.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DatePlanForm extends StatefulWidget {
  const DatePlanForm({super.key});

  @override
  State<DatePlanForm> createState() => _DatePlanFormState();
}

class _DatePlanFormState extends State<DatePlanForm> {
  final _formKey = GlobalKey<FormState>();

  /// Controllers – init NGAY, không late
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();
  final TextEditingController budgetCtrl = TextEditingController();

  DateTime? plannedStartAt;
  DateTime? plannedEndAt;

  @override
  void dispose() {
    titleCtrl.dispose();
    noteCtrl.dispose();
    budgetCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (plannedStartAt == null || plannedEndAt == null) {
      showMsg(context, "Vui lòng chọn thời gian hẹn", false);
      return;
    }

    final estimatedBudget = double.tryParse(budgetCtrl.text.trim()) ?? 0;

    final request = DatePlanCreateAndUpdateRequest(
      title: titleCtrl.text.trim(),
      note: noteCtrl.text.trim(),
      plannedStartAt: plannedStartAt!,
      plannedEndAt: plannedEndAt!,
      estimatedBudget: estimatedBudget,
    );

    final provider = context.read<DatePlanProvider>();
    await provider.createDatePlan(request);

    if (!mounted) return;

    if (provider.error != null) {
      showMsg(context, provider.error!, false);
    } else {
      showMsg(context, "Tạo kế hoạch hẹn hò thành công", true);
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TitleInput(controller: titleCtrl),
          const SizedBox(height: 16),

          DateTimePickerSection(
            onStartChanged: (v) => setState(() => plannedStartAt = v),
            onEndChanged: (v) => setState(() => plannedEndAt = v),
          ),
          const SizedBox(height: 16),

          BudgetInput(controller: budgetCtrl),
          const SizedBox(height: 32),

          NoteInput(controller: noteCtrl),
          const SizedBox(height: 16),

          SubmitButton(onPressed: _submit, label: "Tạo lịch hẹn 💖"),
        ],
      ),
    );
  }
}
