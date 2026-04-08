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

    /// ===============================
    /// 1. CUSTOM SCHEME
    /// ===============================
    if (uri.scheme == 'couplemood') {
      /// PAYMENT
      if (uri.host == 'payment-result') {
        final qp = uri.queryParameters;

        final orderId = qp['orderId'];
        final appTransId = qp['appTransID'];
        final transactionId = qp['transactionId'];

        final id = orderId ?? appTransId ?? transactionId;

        String? method;
        if (orderId != null) {
          method = 'MOMO';
        } else if (appTransId != null) {
          method = 'ZALOPAY';
        } else {
          method = qp['paymentMethod'];
        }

        if (id == null || id.isEmpty) return;

        widget.router.goNamed(
          'payment-result',
          extra: {'id': id, 'method': method},
        );
      } else if (uri.host == 'post') {
        if (uri.pathSegments.isNotEmpty) {
          final code = uri.pathSegments.last;

          widget.router.goNamed(
            'post_detail_from_share',
            pathParameters: {'code': code},
          );
        }
      }

      return;
    }
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
