import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/wallet/withdraw_request.dart';

class WithdrawalHistoryList extends StatefulWidget {
  final List<WithdrawRequest> requests;
  final bool isLoading;

  const WithdrawalHistoryList({
    super.key,
    required this.requests,
    required this.isLoading,
  });

  @override
  State<WithdrawalHistoryList> createState() => _WithdrawalHistoryListState();
}

class _WithdrawalHistoryListState extends State<WithdrawalHistoryList> {
  final ScrollController _controller = ScrollController();
  static const int _step = 6;
  int _currentLimit = 6;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 100) {
        _loadMore();
      }
    });
  }

  void _loadMore() {
    if (_currentLimit >= widget.requests.length) return;

    setState(() {
      _currentLimit = (_currentLimit + _step).clamp(0, widget.requests.length);
    });
  }

  @override
  void didUpdateWidget(covariant WithdrawalHistoryList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.requests != widget.requests) {
      _currentLimit = 6;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatVND(int amount) => NumberFormat('#,###', 'vi_VN').format(amount);

  String _safeLastFour(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    return accountNumber.substring(accountNumber.length - 4);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.requests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            "Chưa có lịch sử rút tiền nào",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
      );
    }

    final displayList = widget.requests.take(_currentLimit).toList();

    return ListView.builder(
      controller: _controller,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final req = displayList[index];

        final isCompleted = req.status.toUpperCase() == "COMPLETED";
        final isRejected = req.status.toUpperCase() == "REJECTED";

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW
                Row(
                  children: [
                    const Icon(Icons.account_balance, color: Colors.orange),
                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${formatVND(req.amount)}đ",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${req.bankInfo.bankName} • ${_safeLastFour(req.bankInfo.accountNumber)}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            req.bankInfo.accountName,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                    _buildStatusBadge(req.status),
                  ],
                ),

                const SizedBox(height: 10),

                /// REJECT REASON
                if (isRejected && req.rejectionReason != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Lý do: ${req.rejectionReason}",
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),

                /// PROOF IMAGE
                if (isCompleted && req.proofImageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                backgroundColor: Colors.black,
                                insetPadding: const EdgeInsets.all(10),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: InteractiveViewer(
                                        child: Image.network(
                                          req.proofImageUrl!,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            req.proofImageUrl!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat('dd/MM').format(req.requestedAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status.toUpperCase()) {
      case 'COMPLETED':
        color = Colors.green;
        text = "Thành công";
        break;
      case 'APPROVED':
        color = Colors.blue;
        text = "Đã duyệt";
        break;
      case 'REJECTED':
        color = Colors.red;
        text = "Từ chối";
        break;
      default:
        color = Colors.orange;
        text = "Đang xử lý";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
