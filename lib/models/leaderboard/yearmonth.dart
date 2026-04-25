class YearMonth {
  final int year;
  final int month;

  YearMonth(this.year, this.month);

  @override
  String toString() => 'Tháng $month/$year';
}

List<YearMonth> getLast12Months() {
  final now = DateTime.now();
  return List.generate(12, (index) {
    final date = DateTime(now.year, now.month - index);
    return YearMonth(date.year, date.month);
  });
}
