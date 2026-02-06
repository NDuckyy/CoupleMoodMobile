import 'package:couple_mood_mobile/models/dateplan/date_plan_create_request.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/screens/dateplan/createDatePlan/widget/budget_input.dart';
import 'package:couple_mood_mobile/screens/dateplan/createDatePlan/widget/date_time_picker_section.dart';
import 'package:couple_mood_mobile/screens/dateplan/createDatePlan/widget/note_input.dart';
import 'package:couple_mood_mobile/screens/dateplan/createDatePlan/widget/submit_button.dart';
import 'package:couple_mood_mobile/screens/dateplan/createDatePlan/widget/title_input.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DatePlanForm extends StatefulWidget {
  const DatePlanForm({super.key});

  @override
  State<DatePlanForm> createState() => _DatePlanFormState();
}

class _DatePlanFormState extends State<DatePlanForm> {
  String title = '';
  String note = '';
  double estimatedBudget = 0;

  DateTime? plannedStartAt;
  DateTime? plannedEndAt;

  void _submit() async {
    if (title.isEmpty || plannedStartAt == null || plannedEndAt == null) {
      showMsg(context, "Vui lòng điền đầy đủ thông tin", false);
      return;
    }

    final request = DatePlanCreateRequest(
      title: title,
      note: note,
      plannedStartAt: plannedStartAt!,
      plannedEndAt: plannedEndAt!,
      estimatedBudget: estimatedBudget,
    );

    final datePlanProvider = context.read<DatePlanProvider>();
    await datePlanProvider.createDatePlan(request);
    if (datePlanProvider.error != null) {
      if (!mounted) return;
      showMsg(context, datePlanProvider.error!, false);
    } else {
      if (!mounted) return;
      showMsg(context, "Tạo kế hoạch hẹn hò thành công", true);
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleInput(onChanged: (value) => title = value),
        const SizedBox(height: 16),

        NoteInput(onChanged: (value) => note = value),
        const SizedBox(height: 16),

        DateTimePickerSection(
          onStartChanged: (date) => plannedStartAt = date,
          onEndChanged: (date) => plannedEndAt = date,
        ),
        const SizedBox(height: 16),

        BudgetInput(
          onChanged: (value) => estimatedBudget = double.tryParse(value) ?? 0,
        ),
        const SizedBox(height: 32),

        SubmitButton(onPressed: _submit),
      ],
    );
  }
}
