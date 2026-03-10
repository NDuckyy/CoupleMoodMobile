import 'package:intl/intl.dart';

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
