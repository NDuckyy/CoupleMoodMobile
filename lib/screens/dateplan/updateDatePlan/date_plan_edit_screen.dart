import 'package:couple_mood_mobile/models/dateplan/date_plan_create_request.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';
import 'package:couple_mood_mobile/widgets/datePlan/budget_input.dart';
import 'package:couple_mood_mobile/widgets/datePlan/duration_mode_input.dart';
import 'package:couple_mood_mobile/widgets/datePlan/note_input.dart';
import 'package:couple_mood_mobile/widgets/datePlan/submit_button.dart';
import 'package:couple_mood_mobile/widgets/datePlan/title_input.dart';
import 'package:couple_mood_mobile/screens/dateplan/updateDatePlan/widget/date_time.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UpdateDatePlanScreen extends StatefulWidget {
  final int datePlanId;

  const UpdateDatePlanScreen({super.key, required this.datePlanId});

  @override
  State<UpdateDatePlanScreen> createState() => _UpdateDatePlanScreenState();
}

class _UpdateDatePlanScreenState extends State<UpdateDatePlanScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleCtrl = TextEditingController();
  late final TextEditingController budgetCtrl = TextEditingController();
  late final TextEditingController noteCtrl = TextEditingController();
  final TextEditingController durationModeCtrl = TextEditingController();

  DateTime? startAt;
  DateTime? endAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  Future<void> _initData() async {
    final provider = context.read<DatePlanProvider>();
    await provider.getDatePlanDetails(widget.datePlanId);

    final detail = provider.selectedDatePlan!;
    titleCtrl.text = detail.data?.title ?? '';
    budgetCtrl.text = detail.data?.estimatedBudget.toString() ?? '';
    noteCtrl.text = detail.data?.note ?? '';
    durationModeCtrl.text = detail.data?.durationMode ?? '';
    startAt =
        DateTime.tryParse(detail.data?.plannedStartAt ?? '') ??
        DateTime.now();

    endAt =
        DateTime.tryParse(detail.data?.plannedEndAt ?? '') ??
        DateTime.now().add(const Duration(hours: 1));

    setState(() {});
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    budgetCtrl.dispose();
    noteCtrl.dispose();
    durationModeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (startAt == null || endAt == null) {
      showMsg(context, "Vui lòng chọn thời gian", false);
      return;
    }

    if (endAt!.isBefore(startAt!)) {
      showMsg(context, "Thời gian kết thúc phải sau thời gian bắt đầu", false);
      return;
    }

    if (endAt!.difference(startAt!).inMinutes < 60) {
      showMsg(context, "Thời gian cuộc hẹn phải dài hơn 1 tiếng", false);
      return;
    }

    final provider = context.read<DatePlanProvider>();
    final estimatedBudget = double.tryParse(budgetCtrl.text.trim()) ?? 0;
    if (estimatedBudget < 0) {
      showMsg(context, "Ngân sách ước tính không được âm", false);
      return;
    }
    if (estimatedBudget > 1000000000) {
      showMsg(context, "Ngân sách không vượt quá 1 tỷ", false);
      return;
    }
    await provider.updateDatePlan(
      id: widget.datePlanId,
      request: DatePlanCreateAndUpdateRequest(
        title: titleCtrl.text.trim(),
        plannedStartAt: startAt!.toUtc(),
        plannedEndAt: endAt!.toUtc(),
        estimatedBudget: estimatedBudget,
        note: noteCtrl.text.trim(),
        durationMode: durationModeCtrl.text.trim().isNotEmpty
            ? durationModeCtrl.text.trim()
            : null,
        version: provider.selectedDatePlan?.data?.version ?? 1,
      ),
    );

    if (!mounted) return;

    if (provider.error != null) {
      showMsg(context, provider.error!, false);
    } else {
      showMsg(context, 'Cập nhật lịch hẹn thành công', true);
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DatePlanProvider>();

    if (provider.isLoading || startAt == null || endAt == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chỉnh sửa lịch hẹn'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TitleInput(controller: titleCtrl),
              const SizedBox(height: 16),

              DatePlanDateTimePicker(
                start: startAt!,
                end: endAt!,
                onStartChanged: (v) => setState(() => startAt = v),
                onEndChanged: (v) => setState(() => endAt = v),
              ),
              const SizedBox(height: 16),

              BudgetInput(controller: budgetCtrl),
              const SizedBox(height: 16),

              NoteInput(controller: noteCtrl),
              const SizedBox(height: 32),

              DurationModeInput(controller: durationModeCtrl),
              const SizedBox(height: 16),

              SubmitButton(onPressed: _submit, label: "Cập nhật lịch hẹn 💖"),
            ],
          ),
        ),
      ),
    );
  }
}
