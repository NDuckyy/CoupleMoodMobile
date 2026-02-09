import 'package:couple_mood_mobile/screens/datePlanItem/datePlanItem/widget/date_plan_item_card.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/datePlanItem/widget/date_plan_item_header.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
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

  Future<void> _reload() async {
    await _initDatePlanItems(context);
  }

  void _onDeleteItem(int datePlanId, int datePlanItemId) async {
    try {
      final datePlanProvider = context.read<DatePlanProvider>();
      await datePlanProvider.deleteDatePlanItem(datePlanId, datePlanItemId);
      if (datePlanProvider.error != null) {
        if (!mounted) return;
        showMsg(context, datePlanProvider.error!, false);
      } else {
        if (!mounted) return;
        showMsg(context, 'Xóa địa điểm khỏi lịch hẹn thành công', true);
        await datePlanProvider.fetchDatePlanItems(datePlanId);
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint("Error deleting date plan item: $e");
      showMsg(context, "$e", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DatePlanProvider>();
    final items = provider.datePlanItems?.data?.items ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _reload,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: DatePlanItemHeader(),
                      ),
                    ),
                    items.isEmpty
                        ? SliverToBoxAdapter(
                            child: Column(
                              children: const [
                                SizedBox(height: 200),
                                EmptyStateWidget(
                                  icon: Icons.location_on_outlined,
                                  title: 'Chưa có địa điểm nào trong lịch hẹn',
                                  description:
                                      'Bạn chưa thêm địa điểm nào cho lịch hẹn này. Hãy thêm địa điểm để bắt đầu lên kế hoạch cho những buổi hẹn hò đáng nhớ cùng người ấy nhé!',
                                ),
                              ],
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.all(24),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return DatePlanItemCard(
                                  item: items[index],
                                  onDelete: () {
                                    _onDeleteItem(
                                      items[index].datePlanId,
                                      items[index].id,
                                    );
                                  },
                                );
                              }, childCount: items.length),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
