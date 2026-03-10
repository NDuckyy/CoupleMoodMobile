import '../../services/api_client.dart';
import '../../models/chat/conversation.dart';
import '../../models/chat/message.dart';
import '../../models/chat/chat_models.dart';
import '../../models/chat/user_search_result.dart';

class MessagingApiService {
  // ==================== USER SEARCH ====================
  
  /// Search users for creating conversations
  static Future<UserSearchResponse> searchUsers({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await ApiClient.request(
        '/couple-invitations/search',
        method: HttpMethod.get,
        query: {
          'query': query,
          'page': page.toString(),
          'pageSize': pageSize.toString(),
        },
      );
      return UserSearchResponse.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to search users: ${e.toString()}');
    }
  }

  // ==================== CONVERSATIONS ====================
  
  /// Get all conversations for the current user
  /// GET /api/messaging/conversations
  static Future<List<Conversation>> getAllConversations() async {
    try {
      final response = await ApiClient.request(
        '/messaging/conversations',
        method: HttpMethod.get,
      );
      
      if (response is List<dynamic>) {
        return response
            .map((c) => Conversation.fromJson(c as Map<String, dynamic>))
            .toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get conversations: ${e.toString()}');
    }
  }

  /// Create a new conversation (DIRECT or GROUP)
  /// POST /api/messaging/conversations
  static Future<Conversation> createConversation({
    required String type, // "DIRECT" | "GROUP"
    String? name,
    required List<int> memberIds,
  }) async {
    try {
      final response = await ApiClient.request(
        '/messaging/conversations',
        method: HttpMethod.post,
        data: {
          'type': type,
          'name': name,
          'memberIds': memberIds,
        },
      );
      return Conversation.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create conversation: ${e.toString()}');
    }
  }

  /// Get or create direct conversation with another user
  /// POST /api/messaging/conversations/direct/{otherUserId}
  static Future<Conversation> getOrCreateDirectConversation(int otherUserId) async {
    try {
      final response = await ApiClient.request(
        '/messaging/conversations/direct/$otherUserId',
        method: HttpMethod.post,
      );
      return Conversation.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get/create direct conversation: ${e.toString()}');
    }
  }

  /// Get conversation by ID
  /// GET /api/messaging/conversations/{conversationId}
  static Future<Conversation> getConversationById(int conversationId) async {
    try {
      final response = await ApiClient.request(
        '/messaging/conversations/$conversationId',
        method: HttpMethod.get,
      );
      return Conversation.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get conversation: ${e.toString()}');
    }
  }

  /// Add members to group conversation
  /// POST /api/messaging/conversations/{conversationId}/members
  static Future<void> addMembersToGroup({
    required int conversationId,
    required List<int> memberIds,
  }) async {
    try {
      await ApiClient.request(
        '/messaging/conversations/$conversationId/members',
        method: HttpMethod.post,
        data: {'memberIds': memberIds},
      );
    } catch (e) {
      throw Exception('Failed to add members: ${e.toString()}');
    }
  }

  /// Remove member from group
  /// DELETE /api/messaging/conversations/{conversationId}/members/{memberId}
  static Future<void> removeMemberFromGroup({
    required int conversationId,
    required int memberId,
  }) async {
    try {
      await ApiClient.request(
        '/messaging/conversations/$conversationId/members/$memberId',
        method: HttpMethod.delete,
      );
    } catch (e) {
      throw Exception('Failed to remove member: ${e.toString()}');
    }
  }

  /// Leave conversation
  /// POST /api/messaging/conversations/{conversationId}/leave
  static Future<void> leaveConversation(int conversationId) async {
    try {
      await ApiClient.request(
        '/messaging/conversations/$conversationId/leave',
        method: HttpMethod.post,
      );
    } catch (e) {
      throw Exception('Failed to leave conversation: ${e.toString()}');
    }
  }

  // ==================== MESSAGES ====================

  /// Send a message (text or file)
  /// POST /api/messaging/messages
  static Future<Message> sendMessage({
    required int conversationId,
    required String messageType, // "TEXT" | "IMAGE" | "VIDEO" | "AUDIO" | "FILE"
    String? content,
    int? referenceId,
    String? referenceType,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? metadata,
  }) async {
    try {
      final data = <String, dynamic>{
        'conversationId': conversationId,
        'messageType': messageType,
      };
      
      if (messageType == 'TEXT') {
        if (content == null || content.isEmpty) {
          throw Exception('Content is required for TEXT messages');
        }
        data['content'] = content;
      } else if (messageType == 'DATE_PLAN') {
        if (referenceId ==  null || referenceType == null || referenceType.isEmpty) {
          throw Exception('referenceId and referenceType are required for DATE_PLAN messages');
        }
        data['referenceId'] = referenceId;
        data['referenceType'] = referenceType;
      } else {
        // File types
        if (fileUrl == null || fileUrl.isEmpty) {
          throw Exception('fileUrl is required for file messages');
        }
        data['fileUrl'] = fileUrl;
        data['fileName'] = fileName;
        data['fileSize'] = fileSize;
        data['content'] = content ?? fileName ?? '';
      }
      
      if (metadata != null) {
        data['metadata'] = metadata;
      }
      
      final response = await ApiClient.request(
        '/messaging/messages',
        method: HttpMethod.post,
        data: data,
      );
      return Message.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  /// Upload attachment
  /// POST /api/messaging/upload-attachment
  static Future<Map<String, dynamic>> uploadAttachment(dynamic file) async {
    try {
      final response = await ApiClient.request(
        '/messaging/upload-attachment',
        method: HttpMethod.post,
        data: file, // multipart/form-data
      );
      
      // Returns: {fileUrl, fileName, fileSize, messageType}
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to upload attachment: ${e.toString()}');
    }
  }

  /// Get messages with pagination
  /// GET /api/messaging/conversations/{conversationId}/messages
  static Future<MessagesPage> getMessages({
    required int conversationId,
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await ApiClient.request(
        '/messaging/conversations/$conversationId/messages',
        method: HttpMethod.get,
        query: {
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString(),
        },
      );
      return MessagesPage.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get messages: ${e.toString()}');
    }
  }

  /// Mark message as read
  /// POST /api/messaging/messages/read
  static Future<void> markMessageAsRead({
    required int conversationId,
    required int messageId,
  }) async {
    try {
      await ApiClient.request(
        '/messaging/messages/read',
        method: HttpMethod.post,
        data: {
          'conversationId': conversationId,
          'messageId': messageId,
        },
      );
    } catch (e) {
      throw Exception('Failed to mark as read: ${e.toString()}');
    }
  }

  /// Delete a message
  /// DELETE /api/messaging/messages/{messageId}
  static Future<void> deleteMessage(int messageId) async {
    try {
      await ApiClient.request(
        '/messaging/messages/$messageId',
        method: HttpMethod.delete,
      );
    } catch (e) {
      throw Exception('Failed to delete message: ${e.toString()}');
    }
  }

  /// Search messages in conversation
  /// GET /api/messaging/conversations/{conversationId}/messages/search
  static Future<List<Message>> searchMessages({
    required int conversationId,
    required String searchTerm,
  }) async {
    try {
      final response = await ApiClient.request(
        '/messaging/conversations/$conversationId/messages/search',
        method: HttpMethod.get,
        query: {
          'searchTerm': searchTerm,
        },
      );
      
      if (response is List<dynamic>) {
        return response
            .map((m) => Message.fromJson(m as Map<String, dynamic>))
            .toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to search messages: ${e.toString()}');
    }
  }

  static Future<int> getCoupleConversationId() async {
    try {
      final response = await ApiClient.request(
        '/Messaging/conversations/couple',
        method: HttpMethod.get,
      );
    return response['id'] as int;
    } catch (e) {
      throw Exception('Failed to get couple conversation ID: ${e.toString()}');
    }
  }
}
