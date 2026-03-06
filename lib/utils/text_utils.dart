String? getVietnameseFirstName(String? fullName) {
  if (fullName == null || fullName.trim().isEmpty) return null;

  final parts = fullName.trim().split(RegExp(r'\s+'));
  return parts.isNotEmpty ? parts.last : null;
}
