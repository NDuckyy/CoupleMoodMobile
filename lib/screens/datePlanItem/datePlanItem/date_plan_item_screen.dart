import 'package:couple_mood_mobile/screens/datePlanItem/datePlanItem/widget/date_plan_item_card.dart';
import 'package:couple_mood_mobile/screens/datePlanItem/datePlanItem/widget/date_plan_item_header.dart';
import 'package:couple_mood_mobile/widgets/empty_widget.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/providers/date_plan_provider.dart';

class DatePlanItemScreen extends StatefulWidget {
  final int datePlanId;
  final String status;
  const DatePlanItemScreen({super.key, required this.datePlanId, required this.status});

  @override
  State<DatePlanItemScreen> createState() => _DatePlanItemScreenState();
}

Future<void> _initDatePlanItems(BuildContext context, int datePlanId) async {
  await context.read<DatePlanProvider>().fetchDatePlanItems(datePlanId);
}

class _DatePlanItemScreenState extends State<DatePlanItemScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDatePlanItems(context, widget.datePlanId);
    });
  }

  Future<void> _reload() async {
    await _initDatePlanItems(context, widget.datePlanId);
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
                        child: DatePlanItemHeader(
                          datePlanId: widget.datePlanId,
                          status: widget.status,
                          onCreated: () async {
                            await _reload();
                            if (!context.mounted) return;
                            showMsg(
                              context,
                              "Đã thêm mục lịch hẹn hò thành công",
                              true,
                            );
                          },
                        ),
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
                            sliver: SliverReorderableList(
                              itemCount: items.length,
                              onReorder: (oldIndex, newIndex) async {
                                try {
                                  await context
                                      .read<DatePlanProvider>()
                                      .reorderDatePlanItems(
                                        widget.datePlanId,
                                        oldIndex,
                                        newIndex,
                                      );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  showMsg(context, "$e", false);
                                }
                              },

                              itemBuilder: (context, index) {
                                final item = items[index];

                                return Container(
                                  key: ValueKey(item.id),
                                  child: DatePlanItemCard(
                                    item: item,
                                    index: index,
                                    onDelete: () {
                                      _onDeleteItem(item.datePlanId, item.id);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
