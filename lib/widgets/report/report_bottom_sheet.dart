import 'package:couple_mood_mobile/providers/report/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/models/report/report_target_type.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';

class ReportBottomSheet extends StatefulWidget {
  final int targetId;
  final ReportTargetType targetType;

  const ReportBottomSheet({
    super.key,
    required this.targetId,
    required this.targetType,
  });

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  int? selectedTypeId;
  bool _autoSelected = false;
  final TextEditingController reasonController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final isVoucherReport = widget.targetType == ReportTargetType.voucher;

    final filteredTypes = provider.reportTypes.where((type) {
      final isVoucherType = type.typeName.contains("VOUCHER");

      if (isVoucherReport) {
        return isVoucherType; // chỉ voucher
      } else {
        return !isVoucherType; // loại voucher ra
      }
    }).toList();

    if (!_autoSelected && isVoucherReport && filteredTypes.isNotEmpty) {
      final voucherType = filteredTypes.first;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedTypeId = voucherType.id;
          _autoSelected = true;
        });
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: provider.loading
                ? const SizedBox(
                    height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        /// title
                        const Text(
                          "Báo cáo nội dung",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          "Chọn lý do phù hợp",
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 16),

                        /// LIST TYPE
                        ...filteredTypes.map((type) {
                          final isSelected = selectedTypeId == type.id;

                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedTypeId = type.id);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFF1E6FF)
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFB388EB)
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: const Color(0xFFB388EB),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      type.description ?? type.typeName,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        /// reason input
                        TextField(
                          controller: reasonController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Thêm lý do (không bắt buộc)",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (provider.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              provider.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                provider.submitting || selectedTypeId == null
                                ? null
                                : () async {
                                    FocusScope.of(context).unfocus();

                                    final success = await provider.submitReport(
                                      reportTypeId: selectedTypeId!,
                                      targetType: widget.targetType,
                                      targetId: widget.targetId,
                                      reason: reasonController.text.trim(),
                                    );

                                    if (!mounted) return;

                                    Navigator.pop(context);

                                    showMsg(
                                      context,
                                      success
                                          ? (provider.message ??
                                                "Báo cáo đã được gửi")
                                          : (provider.error ??
                                                "Gửi báo cáo thất bại"),
                                      success,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB388EB),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: provider.submitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Gửi báo cáo",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

Future<void> showReportBottomSheet({
  required BuildContext context,
  required int targetId,
  required ReportTargetType targetType,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider(
      create: (_) => ReportProvider()..loadReportTypes(),
      child: ReportBottomSheet(targetId: targetId, targetType: targetType),
    ),
  );
}
