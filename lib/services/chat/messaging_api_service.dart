import '../../services/api_client.dart';
import '../../models/chat/conversation.dart';
import '../../models/chat/message.dart';
import '../../models/chat/chat_models.dart';

class MessagingApiService {
  // ==================== CONVERSATIONS ====================
  
  /// Create a new group conversation
  static Future<Conversation> createGroupConversation({
    required String name,
    required List<int> memberIds,
  }) async {
    final response = await ApiClient.request(
      '/messaging/conversations',
      method: HttpMethod.post,
      data: {
        'type': 'GROUP',
        'name': name,
        'memberIds': memberIds,
      },
    );
    return Conversation.fromJson(response as Map<String, dynamic>);
  }

  /// Get or create a direct conversation with another user
  static Future<Conversation> getOrCreateDirectConversation(int otherUserId) async {
    final response = await ApiClient.request(
      '/messaging/conversations/direct/$otherUserId',
      method: HttpMethod.post,
    );
    return Conversation.fromJson(response as Map<String, dynamic>);
  }

  /// Get all conversations for the current user
  static Future<List<Conversation>> getAllConversations() async {
    final response = await ApiClient.request(
      '/messaging/conversations',
      method: HttpMethod.get,
    );
    return (response as List<dynamic>)
        .map((c) => Conversation.fromJson(c as Map<String, dynamic>))
        .toList();
  }

  /// Get a specific conversation by ID
  static Future<Conversation> getConversationById(int conversationId) async {
    final response = await ApiClient.request(
      '/messaging/conversations/$conversationId',
      method: HttpMethod.get,
    );
    return Conversation.fromJson(response as Map<String, dynamic>);
  }

  /// Add members to a group conversation (ADMIN only)
  static Future<void> addMembersToGroup({
    required int conversationId,
    required List<int> memberIds,
  }) async {
    await ApiClient.request(
      '/messaging/conversations/$conversationId/members',
      method: HttpMethod.post,
      data: {
        'conversationId': conversationId,
        'memberIds': memberIds,
      },
    );
  }

  /// Remove a member from a group conversation (ADMIN only)
  static Future<void> removeMemberFromGroup({
    required int conversationId,
    required int userId,
  }) async {
    await ApiClient.request(
      '/messaging/conversations/$conversationId/members/$userId',
      method: HttpMethod.delete,
    );
  }

  /// Leave a group conversation
  static Future<void> leaveGroup(int conversationId) async {
    await ApiClient.request(
      '/messaging/conversations/$conversationId/leave',
      method: HttpMethod.post,
    );
  }

  // ==================== MESSAGES ====================

  /// Send a text message
  static Future<Message> sendTextMessage({
    required int conversationId,
    required String content,
  }) async {
    final response = await ApiClient.request(
      '/messaging/messages',
      method: HttpMethod.post,
      data: {
        'conversationId': conversationId,
        'content': content,
        'messageType': 'TEXT',
      },
    );
    return Message.fromJson(response as Map<String, dynamic>);
  }

  /// Send a rich message (Date Plan, Location, etc.)
  static Future<Message> sendRichMessage({
    required int conversationId,
    required String content,
    required String messageType,
    int? referenceId,
    String? referenceType,
    String? metadata,
  }) async {
    final response = await ApiClient.request(
      '/messaging/messages',
      method: HttpMethod.post,
      data: {
        'conversationId': conversationId,
        'content': content,
        'messageType': messageType,
        if (referenceId != null) 'referenceId': referenceId,
        if (referenceType != null) 'referenceType': referenceType,
        if (metadata != null) 'metadata': metadata,
      },
    );
    return Message.fromJson(response as Map<String, dynamic>);
  }

  /// Get messages with pagination
  static Future<MessagesPage> getMessages({
    required int conversationId,
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    final response = await ApiClient.request(
      '/messaging/conversations/$conversationId/messages',
      method: HttpMethod.get,
      query: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return MessagesPage.fromJson(response as Map<String, dynamic>);
  }

  /// Mark messages as read
  static Future<void> markAsRead({
    required int conversationId,
    required int messageId,
  }) async {
    await ApiClient.request(
      '/messaging/messages/read',
      method: HttpMethod.post,
      data: {
        'conversationId': conversationId,
        'messageId': messageId,
      },
    );
  }

  /// Delete a message
  static Future<void> deleteMessage(int messageId) async {
    await ApiClient.request(
      '/messaging/messages/$messageId',
      method: HttpMethod.delete,
    );
  }

  /// Search messages in a conversation
  static Future<List<Message>> searchMessages({
    required int conversationId,
    required String searchTerm,
  }) async {
    final response = await ApiClient.request(
      '/messaging/conversations/$conversationId/messages/search',
      method: HttpMethod.get,
      query: {
        'searchTerm': searchTerm,
      },
    );
    return (response as List<dynamic>)
        .map((m) => Message.fromJson(m as Map<String, dynamic>))
        .toList();
  }
}
