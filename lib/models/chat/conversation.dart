import 'conversation_member.dart';
import 'message.dart';

class Conversation {
  final int id;
  final String type; // "DIRECT" | "GROUP"
  final String? name;
  final int createdBy;
  final DateTime createdAt;
  final List<ConversationMember> members;
  final Message? lastMessage;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.type,
    this.name,
    required this.createdBy,
    required this.createdAt,
    required this.members,
    this.lastMessage,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as int,
      type: json['type'] as String,
      name: json['name'] as String?,
      createdBy: json['createdBy'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      members: (json['members'] as List<dynamic>)
          .map((m) => ConversationMember.fromJson(m as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'members': members.map((m) => m.toJson()).toList(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
    };
  }

  Conversation copyWith({
    int? id,
    String? type,
    String? name,
    int? createdBy,
    DateTime? createdAt,
    List<ConversationMember>? members,
    Message? lastMessage,
    int? unreadCount,
  }) {
    return Conversation(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  // Helper methods
  String getDisplayName(int currentUserId) {
    if (type == 'GROUP') {
      return name ?? 'Group Chat';
    }
    // For DIRECT, return the other user's name
    final otherMember = members.firstWhere(
      (m) => m.userId != currentUserId,
      orElse: () => members.first,
    );
    return otherMember.fullName;
  }

  String? getDisplayAvatar(int currentUserId) {
    if (type == 'GROUP') {
      return null; // Will show group icon
    }
    // For DIRECT, return the other user's avatar
    final otherMember = members.firstWhere(
      (m) => m.userId != currentUserId,
      orElse: () => members.first,
    );
    return otherMember.avatar;
  }

  bool getOnlineStatus(int currentUserId) {
    if (type == 'GROUP') {
      return members.any((m) => m.userId != currentUserId && m.isOnline);
    }
    // For DIRECT, return the other user's online status
    final otherMember = members.firstWhere(
      (m) => m.userId != currentUserId,
      orElse: () => members.first,
    );
    return otherMember.isOnline;
  }
}
