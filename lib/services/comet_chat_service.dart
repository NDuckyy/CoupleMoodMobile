import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/foundation.dart';

/// Service để quản lý CometChat
/// Chứa các functions cần thiết cho authentication và initialization
class CometChatService {
  // Singleton pattern để đảm bảo chỉ có 1 instance
  static final CometChatService _instance = CometChatService._internal();
  factory CometChatService() => _instance;
  CometChatService._internal();

  // CometChat credentials - Lấy từ CometChat Dashboard
  static const String appId = '16741449bbc40304e'; // Thay bằng App ID của bạn
  static const String region = 'us'; // Thay bằng region của bạn (us/eu/in)
  static const String authKey = 'df9def00b706ea6149861a9dceefbee1594c56a4'; // Thay bằng Auth Key của bạn

  bool _isInitialized = false;

  /// Khởi tạo CometChat SDK
  /// Gọi function này 1 lần duy nhất khi app start
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      UIKitSettings uiKitSettings = (UIKitSettingsBuilder()
            ..subscriptionType = CometChatSubscriptionType.allUsers
            ..region = region
            ..autoEstablishSocketConnection = true
            ..appId = appId
            ..authKey = authKey)
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

  /// Login user vào CometChat
  /// uid: User ID từ backend của bạn
  Future<User?> loginUser(String uid) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      User? loggedInUser = await CometChatUIKit.login(uid);
      debugPrint('✅ User đã login CometChat: ${loggedInUser?.name}');
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

  /// Lấy trạng thái khởi tạo
  bool get isInitialized => _isInitialized;
}
