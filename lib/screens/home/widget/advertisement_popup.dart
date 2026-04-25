import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertisementPopup extends StatelessWidget {
  final String bannerUrl;
  final String targetUrl;
  final VoidCallback? onTap;

  const AdvertisementPopup({
    super.key,
    required this.bannerUrl,
    required this.targetUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () async {
              try {
                await launchUrl(
                  Uri.parse(targetUrl),
                  mode: LaunchMode.externalApplication,
                );
              } catch (e) {
                debugPrint("Không mở được link: $targetUrl");
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                bannerUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.broken_image, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          "Không tải được quảng cáo",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
