class DatePlanItemUpdateRequest {
  final String? startTime;
  final String? endTime;
  final String? note;
  final int? version;

  DatePlanItemUpdateRequest({
    this.startTime,
    this.endTime,
    this.note,
    this.version,
  });

  Map<String, dynamic> toJson() {
    return {
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      if (note != null) 'note': note,
      if (version != null) 'version': version,
    };
  }
}
