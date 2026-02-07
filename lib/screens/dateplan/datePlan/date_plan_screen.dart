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

  void deleteDatePlan(int datePlanId) async {
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
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DatePlanProvider>();
    final datePlanDetails = provider.datePlans?.data;
    final items = datePlanDetails?.pagedResult.items ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<DatePlanProvider>().fetchDatePlans(
              page: provider.pageNumber,
            );
          },
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            provider.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
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
                                deleteDatePlan(items[index].id);
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
