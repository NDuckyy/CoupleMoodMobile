import 'package:couple_mood_mobile/screens/dateplan/createDatePlan/widget/date_plan_form.dart';
import 'package:flutter/material.dart';

class CreateDatePlanScreen extends StatefulWidget {
  const CreateDatePlanScreen({super.key});

  @override
  State<CreateDatePlanScreen> createState() => _CreateDatePlanScreenState();
}

class _CreateDatePlanScreenState extends State<CreateDatePlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tạo lịch hẹn hò 💕'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: DatePlanForm(),
        ),
      ),
    );
  }
}
