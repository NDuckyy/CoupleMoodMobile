import 'conversation_member.dart';
import 'message.dart';

class Conversation {
  final int id;
  final String type; // "DIRECT" | "GROUP"
  final String? name;
  final int createdBy;
  final DateTime createdAt;
  final ConversationMember? otherUser; // Only for DIRECT conversations
  final List<ConversationMember> members;
  final Message? lastMessage;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.type,
    this.name,
    required this.createdBy,
    required this.createdAt,
    this.otherUser,
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
      otherUser: json['otherUser'] != null
          ? ConversationMember.fromJson(json['otherUser'] as Map<String, dynamic>)
          : null,
      members: (json['members'] as List<dynamic>?)
          ?.map((m) => ConversationMember.fromJson(m as Map<String, dynamic>))
          .toList() ?? [],
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
      'otherUser': otherUser?.toJson(),
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
    ConversationMember? otherUser,
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
      otherUser: otherUser ?? this.otherUser,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  // Helper methods
  String getDisplayName() {
    if (type == 'DIRECT' && otherUser != null) {
      return otherUser!.fullName ?? otherUser!.username ?? 'User ${otherUser!.userId}';
    }
    return name ?? 'Group Chat';
  }

  String? getDisplayAvatar() {
    if (type == 'DIRECT' && otherUser != null) {
      return otherUser!.avatar;
    }
    return null; // Will show group icon
  }

  bool getOnlineStatus() {
    if (type == 'DIRECT' && otherUser != null) {
      return otherUser!.isOnline;
    }
    // For GROUP, check if any member is online
    return members.any((m) => m.isOnline);
  }
}
