  import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePlanChatCard extends StatelessWidget {
  final Map<String, dynamic> datePlanInfo;
  final VoidCallback? onTap;

  const DatePlanChatCard({
    super.key,
    required this.datePlanInfo,
    this.onTap,
  });

  String formatDate(String iso) {
    final date = DateTime.parse(iso).toLocal();
    return DateFormat("dd/MM/yyyy").format(date);
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
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.08),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              datePlanInfo["imageUrl"],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
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
                      child: Text(
                        datePlanInfo["venueName"],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        datePlanInfo["status"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    )
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
                  "Budget: ${datePlanInfo["estimatedBudget"]} VND",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 12),

                /// BUTTON
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff8093F1),
                          Color(0xffB388EB),
                        ],
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}