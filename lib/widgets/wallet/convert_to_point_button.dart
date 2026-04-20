import 'package:flutter/material.dart';
import '../../widgets/wallet/convert_to_point_bottom_sheet.dart';

class ConvertToPointButton extends StatelessWidget {
  final ColorScheme colorScheme;

  const ConvertToPointButton({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: OutlinedButton(
        onPressed: () => ConvertToPointBottomSheet.show(context, colorScheme),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.currency_exchange, color: colorScheme.primary, size: 26),
            const SizedBox(width: 12),
            Text(
              "Đổi tiền sang điểm",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
