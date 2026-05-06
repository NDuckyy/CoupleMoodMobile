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

  static String formatPriceVN(double value) {
    if (value >= 1000000000) {
      final billion = value / 1000000000;

      return _formatNumber(billion, "tỷ");
    } else if (value >= 1000000) {
      final million = value / 1000000;

      return _formatNumber(million, "triệu");
    } else if (value >= 1000) {
      return formatVND(value);
    }

    return "${value.toInt()} đ";
  }

  static String _formatNumber(double number, String unit) {
    if (number == number.roundToDouble()) {
      return "${number.toInt()} $unit";
    }

    final formatted = number.toStringAsFixed(1);
    return "$formatted $unit";
  }

  static String getPriceText(double? min, double? max) {
    const threshold = 100000000;

    final safeMin = (min ?? 0).clamp(0, double.infinity).toDouble();
    final safeMax = (max ?? 0).clamp(0, double.infinity).toDouble();

    if ((min == null && max == null) || (safeMin == 0 && safeMax == 0)) {
      return "Miễn phí";
    }

    if (safeMin > safeMax && safeMax != 0) {
      return "${CurrencyUtils.formatPriceVN(safeMax)} - ${CurrencyUtils.formatPriceVN(safeMin)}";
    }

    if (safeMin >= threshold || safeMax >= threshold) {
      return "Giá cao cấp";
    }

    if (min != null && max != null) {
      return "${CurrencyUtils.formatPriceVN(safeMin)} - ${CurrencyUtils.formatPriceVN(safeMax)}";
    }

    if (min != null) {
      return "Từ ${CurrencyUtils.formatPriceVN(safeMin)}";
    }

    return "Dưới ${CurrencyUtils.formatPriceVN(safeMax)}";
  }

  static int parseVND(String text) {
    final raw = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(raw) ?? 0;
  }

  static String formatRaw(num value) {
    return _vndFormatter.format(value);
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
