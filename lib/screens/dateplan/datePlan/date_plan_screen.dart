import 'package:couple_mood_mobile/providers/chat/chat_provider.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlan/widgets/date_plan_over_view.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlan/widgets/pagination_control.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/date_plan_provider.dart';
import 'widgets/date_plan_header.dart';
import 'widgets/date_plan_card.dart';

class DatePlanScreen extends StatefulWidget {
  const DatePlanScreen({super.key});

  @override
  State<DatePlanScreen> createState() => _DatePlanScreenState();
}

class _DatePlanScreenState extends State<DatePlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatePlanProvider>().fetchDatePlans(page: 1);
    });
  }

  void _deleteDatePlan(int datePlanId) async {
    final datePlanProvider = context.read<DatePlanProvider>();
    await datePlanProvider.deleteDatePlan(datePlanId);
    if (datePlanProvider.error != null) {
      if (!mounted) return;
      showMsg(context, datePlanProvider.error!, false);
    } else {
      if (!mounted) return;
      showMsg(context, 'Xóa lịch hẹn thành công', true);
      datePlanProvider.fetchDatePlans(page: datePlanProvider.pageNumber);
    }
  }//'/

  void _sendDatePlan(int datePlanId) async {
    final datePlanProvider = context.read<DatePlanProvider>();
    final chatProvider = context.read<ChatProvider>();
    await datePlanProvider.sendDatePlan(datePlanId);
    await chatProvider.sendDatePlan(32, "", datePlanId);
    if (datePlanProvider.error != null) {
      if (!mounted) return;
      showMsg(context, datePlanProvider.error!, false);
    } else {
      if (!mounted) return;
      showMsg(context, 'Gửi lịch hẹn thành công', true);
      datePlanProvider.fetchDatePlans(page: datePlanProvider.pageNumber);
    }
  }

  void _cancelDatePlan(int datePlanId) async {
    final datePlanProvider = context.read<DatePlanProvider>();
    await datePlanProvider.cancelDatePlan(datePlanId);
    if (datePlanProvider.error != null) {
      if (!mounted) return;
      showMsg(context, datePlanProvider.error!, false);
    } else {
      if (!mounted) return;
      showMsg(context, 'Hủy lịch hẹn thành công', true);
      datePlanProvider.fetchDatePlans(page: datePlanProvider.pageNumber);
    }
  }

  void _completeDatePlan(int datePlanId) async {
    final datePlanProvider = context.read<DatePlanProvider>();
    await datePlanProvider.completeDatePlan(datePlanId);
    if (datePlanProvider.error != null) {
      if (!mounted) return;
      showMsg(context, datePlanProvider.error!, false);
    } else {
      if (!mounted) return;
      showMsg(context, 'Kết thúc lịch hẹn thành công', true);
      datePlanProvider.fetchDatePlans(page: datePlanProvider.pageNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DatePlanProvider>();
    final datePlanDetails = provider.datePlans?.data;
    final items = datePlanDetails?.pagedResult.items ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  await context.read<DatePlanProvider>().fetchDatePlans(
                    page: provider.pageNumber,
                  );
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: DatePlanHeader(),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DatePlanOverview(
                          total: datePlanDetails?.pagedResult.totalCount ?? 0,
                          preparing: datePlanDetails?.totalUpcoming ?? 0,
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    if (provider.error != null) ...{
                      SliverToBoxAdapter(
                        child: EmptyStateWidget(
                          icon: Icons.warning_amber_outlined,
                          title: 'Lỗi',
                          description: provider.error!,
                        ),
                      ),
                    } else if (items.isNotEmpty) ...{
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DatePlanCard(
                              item: items[index],
                              onDelete: () {
                                _deleteDatePlan(items[index].id);
                              },
                              onSend: () {
                                _sendDatePlan(items[index].id);
                              },
                              onCancel: () {
                                _cancelDatePlan(items[index].id);
                              },
                              onComplete: () {
                                _completeDatePlan(items[index].id);
                              },
                            ),
                          );
                        }, childCount: items.length),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 24)),

                      SliverToBoxAdapter(child: PaginationControls()),
                    } else ...{
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      const SliverToBoxAdapter(
                        child: EmptyStateWidget(
                          icon: Icons.event_note,
                          title: 'Chưa có lịch hẹn nào',
                          description:
                              'Bạn chưa tạo lịch hẹn nào. Hãy thêm lịch hẹn để bắt đầu lên kế hoạch cho những buổi hẹn hò đáng nhớ cùng người ấy nhé!',
                        ),
                      ),
                    },
                  ],
                ),
              ),
      ),
    );
  }
}
