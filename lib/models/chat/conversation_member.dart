class ConversationMember {
  final int userId;
  final String username;
  final String fullName;
  final String? avatar;
  final String role; // "MEMBER" | "ADMIN"
  final DateTime joinedAt;
  final bool isOnline;

  ConversationMember({
    required this.userId,
    required this.username,
    required this.fullName,
    this.avatar,
    required this.role,
    required this.joinedAt,
    required this.isOnline,
  });

  factory ConversationMember.fromJson(Map<String, dynamic> json) {
    return ConversationMember(
      userId: json['userId'] as int,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      avatar: json['avatar'] as String?,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'fullName': fullName,
      'avatar': avatar,
      'role': role,
      'joinedAt': joinedAt.toIso8601String(),
      'isOnline': isOnline,
    };
  }

  ConversationMember copyWith({
    int? userId,
    String? username,
    String? fullName,
    String? avatar,
    String? role,
    DateTime? joinedAt,
    bool? isOnline,
  }) {
    return ConversationMember(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
