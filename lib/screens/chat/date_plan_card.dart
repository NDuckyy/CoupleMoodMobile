import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePlanChatCard extends StatelessWidget {
  final Map<String, dynamic> datePlanInfo;
  final VoidCallback? onTap;
  final Function(int datePlanId) onAccept;
  final Function(int datePlanId) onReject;

  const DatePlanChatCard({
    super.key,
    required this.datePlanInfo,
    this.onTap,
    required this.onAccept,
    required this.onReject,
  });

  String formatDate(String iso) {
    final date = DateTime.parse(iso).toLocal();
    return DateFormat("dd/MM/yyyy").format(date);
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'DRAFTED':
        return const Color.fromARGB(255, 255, 230, 0);
      case 'PENDING':
        return Colors.blue;
      case 'SCHEDULED':
        return const Color.fromARGB(255, 206, 87, 227);
      case 'IN_PROGRESS':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = formatDate(datePlanInfo["plannedStartAt"]);
    final end = formatDate(datePlanInfo["plannedEndAt"]);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.08)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          InkWell(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                datePlanInfo["imageDatePlanUrl"],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE + STATUS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: onTap,
                        child: Text(
                          datePlanInfo["title"],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(datePlanInfo["status"]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        datePlanInfo["status"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// DATE
                Text(
                  "$start - $end",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                /// BUDGET
                Text(
                  "Ngân sách: ${datePlanInfo["estimatedBudget"]} VND",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),

                const SizedBox(height: 12),

                /// BUTTON
                datePlanInfo["status"] == "PENDING"
                    ? Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => onReject(datePlanInfo["datePlanId"]),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.redAccent,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Từ chối",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => onAccept(datePlanInfo["datePlanId"]),
                              child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff8093F1),
                                      Color(0xffB388EB),
                                    ],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Đồng ý",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: onTap,
                        child: Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [Color(0xff8093F1), Color(0xffB388EB)],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Xem lịch trình",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
