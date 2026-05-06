import 'package:couple_mood_mobile/models/dateplan/date_plan_response.dart';
import 'package:couple_mood_mobile/providers/chat/chat_provider.dart';
import 'package:couple_mood_mobile/screens/dateplan/datePlan/widgets/date_plan_over_view.dart';
import 'package:couple_mood_mobile/widgets/common/pagination_bar.dart';
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
  List<DatePlanDetails> _items = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPage(1);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          _hasMore) {
        _loadPage(_currentPage + 1);
      }
    });
  }

  Future<void> _loadPage(int page) async {
    if (_isLoadingMore) return;
    if (page != 1 && !_hasMore) return;

    _isLoadingMore = true;

    final provider = context.read<DatePlanProvider>();
    await provider.fetchDatePlans(page: page);

    if (!mounted) {
      _isLoadingMore = false;
      return;
    }

    final newData = provider.datePlans?.data?.pagedResult;

    if (newData == null) {
      _isLoadingMore = false;
      return;
    }

    setState(() {
      if (page == 1) {
        _items = newData.items;
      } else {
        _items.addAll(newData.items);
      }

      _currentPage = newData.pageNumber;
      _hasMore = newData.hasNextPage;
    });

    _isLoadingMore = false;
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
      _refreshDatePlans();
    }
  }

  void _sendDatePlan(int datePlanId) async {
    final datePlanProvider = context.read<DatePlanProvider>();
    final chatProvider = context.read<ChatProvider>();
    try {
      await datePlanProvider.sendDatePlan(datePlanId);
      final conversationId = await chatProvider.getCoupleConversationId();
      if (datePlanProvider.error != null) {
        if (!mounted) return;
        showMsg(context, datePlanProvider.error!, false);
        return;
      } else {
        if (!mounted) return;
        showMsg(context, 'Gửi lịch hẹn thành công', true);
        _refreshDatePlans();
      }
      await chatProvider.sendDatePlan(
        conversationId,
        "Đã gửi 1 lịch hẹn",
        datePlanId,
      );
    } catch (e) {
      if (!mounted) return;
      showMsg(context, 'Gửi lịch hẹn thất bại', false);
    }
  }

  void _onAcceptDatePlan(int datePlanId) async {
    final datePlanProvider = context.read<DatePlanProvider>();
    await datePlanProvider.acceptDatePlan(datePlanId);
    if (datePlanProvider.error != null) {
      if (!mounted) return;
      showMsg(context, datePlanProvider.error!, false);
    } else {
      if (!mounted) return;
      showMsg(context, 'Đã đồng ý lịch hẹn', true);
      _refreshDatePlans();
    }
  }

  void _onRejectDatePlan(int datePlanId) async {
    final datePlanProvider = context.read<DatePlanProvider>();
    await datePlanProvider.rejectDatePlan(datePlanId);
    if (datePlanProvider.error != null) {
      if (!mounted) return;
      showMsg(context, datePlanProvider.error!, false);
    } else {
      if (!mounted) return;
      showMsg(context, 'Đã từ chối lịch hẹn', true);
      _refreshDatePlans();
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
      _refreshDatePlans();
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
      _refreshDatePlans();
    }
  }

  Future<void> _refreshDatePlans() async {
    _currentPage = 1;
    _hasMore = true;
    await _loadPage(1);
  }

  void _onPageChanged(int page) {
    context.read<DatePlanProvider>().fetchDatePlans(page: page);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DatePlanProvider>();
    final datePlanDetails = provider.datePlans?.data;
    final pagination = datePlanDetails?.pagedResult;
    final items = _items;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: (provider.isLoading && _items.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  _refreshDatePlans();
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: DatePlanHeader(
                          onCreate: () => _refreshDatePlans(),
                        ),
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

                    if (items.isNotEmpty) ...{
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index < items.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
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
                                onAccept: () {
                                  _onAcceptDatePlan(items[index].id);
                                },
                                onReject: () {
                                  _onRejectDatePlan(items[index].id);
                                },
                              ),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        }, childCount: items.length + (_isLoadingMore ? 1 : 0)),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 24)),

                      // SliverToBoxAdapter(
                      //   child: PaginationBar(
                      //     currentPage: pagination!.pageNumber,
                      //     totalPages: pagination.totalPages,
                      //     onPageChanged: (page) {
                      //       _onPageChanged(page);
                      //     },
                      //   ),
                      // ),
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
