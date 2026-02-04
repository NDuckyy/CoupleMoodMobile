import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/foundation.dart';
import '../utils/session_storage.dart';

/// Service tổng hợp tất cả chức năng chat
class ChatService {
  // Singleton pattern
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  // CometChat credentials
  static const String appId = '16741449bbc40304e';
  static const String region = 'us';
  static const String authKey = 'df9def00b706ea6149861a9dceefbee1594c56a4';

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // ==================== INITIALIZATION ====================

  /// Khởi tạo CometChat SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      UIKitSettings uiKitSettings = (UIKitSettingsBuilder()
            ..subscriptionType = CometChatSubscriptionType.allUsers
            ..region = region
            ..autoEstablishSocketConnection = true
            ..appId = appId
            ..authKey = authKey
            ..extensions = [])
          .build();

      await CometChatUIKit.init(
        uiKitSettings: uiKitSettings,
        onSuccess: (String successMessage) {
          _isInitialized = true;
          debugPrint('✅ CometChat khởi tạo thành công: $successMessage');
        },
        onError: (CometChatException e) {
          debugPrint('❌ Lỗi khởi tạo CometChat: ${e.message}');
          throw Exception('CometChat initialization failed: ${e.message}');
        },
      );
    } catch (e) {
      debugPrint('❌ Exception khi khởi tạo CometChat: $e');
      rethrow;
    }
  }

  // ==================== LOGIN / LOGOUT ====================

  /// Login user vào CometChat
  Future<User?> loginUser(String uid, {String? name, String? avatarUrl}) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      User? loggedInUser = await CometChatUIKit.login(uid);
      debugPrint('✅ User đã login CometChat: ${loggedInUser?.name}');

      // Cập nhật thông tin user nếu có thay đổi
      if (loggedInUser != null && (name != null || avatarUrl != null)) {
        if ((name != null && loggedInUser.name != name) ||
            (avatarUrl != null && loggedInUser.avatar != avatarUrl)) {
          User user = User(
            uid: uid,
            name: name ?? loggedInUser.name,
            avatar: avatarUrl ?? loggedInUser.avatar,
            role: loggedInUser.role,
          );

          await CometChat.updateCurrentUserDetails(
            user,
            onSuccess: (User updatedUser) {
              debugPrint('✅ Đã cập nhật info user CometChat: ${updatedUser.name}, avatar: ${updatedUser.avatar}');
              loggedInUser = updatedUser;
            },
            onError: (CometChatException e) {
              debugPrint('⚠️ Không thể cập nhật info user: ${e.message}');
            },
          );
        }
      }

      return loggedInUser;
    } on CometChatException catch (e) {
      debugPrint('❌ Lỗi login CometChat: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('❌ Exception login CometChat: $e');
      return null;
    }
  }

  /// Logout user khỏi CometChat
  Future<void> logoutUser() async {
    try {
      await CometChatUIKit.logout();
      debugPrint('✅ User đã logout CometChat');
    } on CometChatException catch (e) {
      debugPrint('❌ Lỗi logout CometChat: ${e.message}');
    }
  }

  /// Kiểm tra user đã login CometChat chưa
  Future<User?> getLoggedInUser() async {
    try {
      User? user = await CometChatUIKit.getLoggedInUser();
      return user;
    } catch (e) {
      debugPrint('❌ Lỗi get logged in user: $e');
      return null;
    }
  }

  /// Login từ session
  Future<User?> loginFromSession() async {
    try {
      final session = await SessionStorage.load();
      final uid = session?.cometChatUid;

      if (uid == null || uid.isEmpty) {
        debugPrint('❌ Không tìm thấy cometChatUid trong SessionStorage');
        await logoutUser();
        return null;
      }

      User? currentUser = await getLoggedInUser();
      
      if (currentUser != null) {
        if (currentUser.uid == uid) {
          debugPrint('✅ CometChat User đã khớp: ${currentUser.name}');
          return currentUser;
        } else {
          debugPrint('⚠️ User mismatch (Current: ${currentUser.uid}, Expected: $uid) -> Logging out...');
          await logoutUser();
        }
      }

      debugPrint('🔐 Tìm thấy UID trong Session: $uid -> Tiến hành login');
      final avatarUrl = session?.avartarUrl;
      return await loginUser(uid, avatarUrl: avatarUrl);
    } catch (e) {
      debugPrint('❌ Exception loginFromSession: $e');
      return null;
    }
  }
}
