import 'package:couple_mood_mobile/screens/dateplan/datePlanItem/widget/date_plan_item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';

class DatePlanItemScreen extends StatefulWidget {
  const DatePlanItemScreen({super.key});

  @override
  State<DatePlanItemScreen> createState() => _DatePlanItemScreenState();
}

Future<void> _initDatePlanItems(BuildContext context) async {
  final GoRouterState state = GoRouterState.of(context);
  final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
  final datePlanId = extra['datePlanId'];

  await context.read<DatePlanProvider>().fetchDatePlanItems(datePlanId);
}

class _DatePlanItemScreenState extends State<DatePlanItemScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDatePlanItems(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DatePlanProvider>();
    final items = provider.datePlanItems?.data?.items ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chi tiết lịch hẹn'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? const Center(child: Text('Chưa có địa điểm nào trong lịch hẹn'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return DatePlanItemCard(item: items[index]);
              },
            ),
    );
  }
}
