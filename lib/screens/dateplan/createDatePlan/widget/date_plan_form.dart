import 'package:couple_mood_mobile/models/dateplan/date_plan_create_request.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/widgets/datePlan/budget_input.dart';
import 'package:couple_mood_mobile/screens/dateplan/createDatePlan/widget/date_time_picker_section.dart';
import 'package:couple_mood_mobile/widgets/datePlan/duration_mode_input.dart';
import 'package:couple_mood_mobile/widgets/datePlan/note_input.dart';
import 'package:couple_mood_mobile/widgets/datePlan/submit_button.dart';
import 'package:couple_mood_mobile/widgets/datePlan/title_input.dart';
import 'package:couple_mood_mobile/widgets/dialogs/show_match_required_dialog.dart';
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
  final TextEditingController durationModeCtrl = TextEditingController();

  DateTime? plannedStartAt;
  DateTime? plannedEndAt;

  @override
  void dispose() {
    titleCtrl.dispose();
    noteCtrl.dispose();
    budgetCtrl.dispose();
    durationModeCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (plannedStartAt == null || plannedEndAt == null) {
      showMsg(context, "Vui lòng chọn thời gian hẹn", false);
      return;
    }

    final estimatedBudget = double.tryParse(budgetCtrl.text.trim()) ?? 0;
    if (estimatedBudget < 0) {
      showMsg(context, "Ngân sách ước tính không được âm", false);
      return;
    }
    if (estimatedBudget > 1000000000) {
      showMsg(context, "Ngân sách không vượt quá 1 tỷ", false);
      return;
    }

    final request = DatePlanCreateAndUpdateRequest(
      title: titleCtrl.text.trim(),
      note: noteCtrl.text.trim(),
      plannedStartAt: plannedStartAt!,
      plannedEndAt: plannedEndAt!,
      estimatedBudget: estimatedBudget,
      durationMode: durationModeCtrl.text.trim().isNotEmpty
          ? durationModeCtrl.text.trim()
          : null,
    );

    final provider = context.read<DatePlanProvider>();
    await provider.createDatePlan(request);

    if (!mounted) return;

    if (provider.error != null) {
      if (provider.error!.contains("chưa thuộc cặp đôi")) {
        showMatchRequiredDialog(context: context, title: "Yêu cầu ghép đôi", description: "Bạn cần ghép đôi để tạo kế hoạch hẹn hò. Bạn có muốn ghép đôi ngay bây giờ không?");
        return;
      }
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

          DurationModeInput(controller: durationModeCtrl),
          const SizedBox(height: 16),

          SubmitButton(onPressed: _submit, label: "Tạo lịch hẹn 💖"),
        ],
      ),
    );
  }
}
