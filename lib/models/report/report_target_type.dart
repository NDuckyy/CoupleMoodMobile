enum ReportTargetType { post, comment, review, user, venue }

extension ReportTargetTypeExt on ReportTargetType {
  String get value {
    switch (this) {
      case ReportTargetType.post:
        return "POST";
      case ReportTargetType.comment:
        return "COMMENT";
      case ReportTargetType.review:
        return "REVIEW";
      case ReportTargetType.user:
        return "USER";
      case ReportTargetType.venue:
        return "VENUE";
    }
  }
}
