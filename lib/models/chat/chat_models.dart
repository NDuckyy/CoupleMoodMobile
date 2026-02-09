class TypingIndicator {
  final int conversationId;
  final int userId;
  final String username;
  final bool isTyping;

  TypingIndicator({
    required this.conversationId,
    required this.userId,
    required this.username,
    required this.isTyping,
  });

  factory TypingIndicator.fromJson(Map<String, dynamic> json) {
    return TypingIndicator(
      conversationId: json['conversationId'] as int,
      userId: json['userId'] as int,
      username: json['username'] as String,
      isTyping: json['isTyping'] as bool,
    );
  }
}

class OnlineStatus {
  final int userId;
  final bool isOnline;
  final DateTime? lastSeen;

  OnlineStatus({
    required this.userId,
    required this.isOnline,
    this.lastSeen,
  });

  factory OnlineStatus.fromJson(Map<String, dynamic> json) {
    return OnlineStatus(
      userId: json['userId'] as int,
      isOnline: json['isOnline'] as bool,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
    );
  }
}

class MessagesPage {
  final List<Map<String, dynamic>> messages;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;

  MessagesPage({
    required this.messages,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory MessagesPage.fromJson(Map<String, dynamic> json) {
    return MessagesPage(
      messages: (json['messages'] as List<dynamic>)
          .map((m) => m as Map<String, dynamic>)
          .toList(),
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
      hasNextPage: json['hasNextPage'] as bool,
    );
  }
}
