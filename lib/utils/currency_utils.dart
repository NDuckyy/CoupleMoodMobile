import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

//format tiền vnd xài chung cho anh em
class CurrencyUtils {
  static final _vndFormatter = NumberFormat('#,###', 'vi_VN');

  static String formatVND(num value) {
    return '${_vndFormatter.format(value)} đ';
  }

  static String formatRangeVND(num min, num max) {
    return '${formatVND(min)} – ${formatVND(max)}/người';
  }
}

//nhập real time tiền vnd đồ á
class VNDInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###', 'vi_VN');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Lấy số thuần
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final number = int.parse(digits);
    final newText = _formatter.format(number); // 10.000

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
