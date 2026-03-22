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
    // 1. Cold start: initial link khi app mở từ deep link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _handleUri(initialUri);
    } catch (e) {
      debugPrint('Initial deep link error: $e');
    }

    // 2. Hot: khi app đang chạy, nhận link mới (MoMo callback foreground/background)
    _sub = _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) _handleUri(uri);
    });
  }

  void _handleUri(Uri uri) {
    debugPrint('Deep link received: $uri'); // Log để debug

    if (uri.scheme != 'couplemood') return;

    if (uri.host == 'payment-result') {
      final orderId = uri.queryParameters['orderId'];
      if (orderId != null && orderId.isNotEmpty) {
        // Optional: check payment status trước nếu cần (nhưng nên async & show loading nếu lâu)
        // await _checkPayment(orderId); // nếu bạn muốn gọi API check ngay

        // Navigate đến route đã define
        widget.router.goNamed('payment-result', extra: orderId);
      }
    }

    // Thêm case khác nếu sau này có deep link kiểu couplemood://invite?code=xxx
    // else if (uri.host == 'invite') { ... }
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
