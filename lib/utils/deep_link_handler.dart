import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeepLinkHandler extends StatefulWidget {
  final Widget child;
  final GoRouter router;

  const DeepLinkHandler({super.key, required this.child, required this.router});

  @override
  State<DeepLinkHandler> createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    /// 1. Cold start
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } catch (e) {
      debugPrint('❌ Initial deep link error: $e');
    }

    /// 2. Hot / resume
    _sub = _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        _handleUri(uri);
      }
    });
  }

  void _handleUri(Uri uri) {
    debugPrint('🔗 Deep link received: $uri');

    /// Chỉ xử lý scheme của app
    if (uri.scheme != 'couplemood') return;

    /// Payment result
    if (uri.host == 'payment-result') {
      final qp = uri.queryParameters;

      /// 🧠 Extract ID (đa gateway)
      final orderId = qp['orderId']; // MoMo
      final appTransId = qp['appTransID']; // ZaloPay
      final transactionId = qp['transactionId']; // fallback

      final id = orderId ?? appTransId ?? transactionId;

      /// 🧠 Detect payment method (dynamic)
      String? method;

      if (orderId != null) {
        method = 'MOMO';
      } else if (appTransId != null) {
        method = 'ZALOPAY';
      } else {
        /// fallback nếu backend có truyền thêm field sau này
        method = qp['paymentMethod'];
      }

      debugPrint('🧾 Parsed payment: id=$id | method=$method');

      /// ❌ Không có id → bỏ
      if (id == null || id.isEmpty) {
        debugPrint('❌ Missing payment id in deep link');
        return;
      }

      /// ⚠️ Không có method → vẫn cho đi nhưng BE có thể fail
      if (method == null) {
        debugPrint('⚠️ Missing payment method → may fail API');
      }

      /// 🚀 Navigate
      widget.router.goNamed(
        'payment-result',
        extra: {'id': id, 'method': method},
      );
    }

    /// 👉 Future: thêm deep link khác ở đây
    /// else if (uri.host == 'invite') { ... }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
