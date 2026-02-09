import 'package:flutter/material.dart';

class EditDatePlanItemScreen extends StatefulWidget {
  final int datePlanItemId;
  final int datePlanId;

  const EditDatePlanItemScreen({super.key, required this.datePlanItemId, required this.datePlanId});

  @override
  State<EditDatePlanItemScreen> createState() => _EditDatePlanItemScreenState();
}

class _EditDatePlanItemScreenState extends State<EditDatePlanItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa mục lịch hẹn hò ${widget.datePlanItemId}')),
      body: Center(child: Text('Edit Date Plan Item Screen for DatePlanId: ${widget.datePlanId}')),
    );
  }
}
