import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VnpayWebviewScreen extends StatefulWidget {
  final String url;

  const VnpayWebviewScreen({super.key, required this.url});

  @override
  State<VnpayWebviewScreen> createState() => _VnpayWebviewScreenState();
}

class _VnpayWebviewScreenState extends State<VnpayWebviewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            /// intercept return URL
            if (url.startsWith("https://couplemood.io.vn/vnpay-return")) {
              final uri = Uri.parse(url);
              final txnRef = uri.queryParameters['vnp_TxnRef'];

              if (txnRef != null && txnRef.isNotEmpty) {
                ///  redirect về payment-result
                context.go('/payment-result?id=$txnRef&method=VNPAY');
              } else {
                Navigator.pop(context);
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán VNPay")),
      body: WebViewWidget(controller: controller),
    );
  }
}
