import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/user/user_provider.dart';

class PremiumGuard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onAllowedTap;
  final bool blockUI; // có disable UI hay không

  const PremiumGuard({
    super.key,
    required this.child,
    this.onAllowedTap,
    this.blockUI = true,
  });

  void _showUpsell(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFFFDC5F5), Color(0xFFB388EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  size: 36,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              /// TITLE
              const Text(
                "Tính năng Premium 💎",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              /// CONTENT
              const Text(
                "Tính năng này chỉ dành cho tài khoản Premium.\nNâng cấp để mở khóa ngay nhé!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),

              const SizedBox(height: 20),

              /// BUTTONS
              Row(
                children: [
                  /// Cancel
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Để sau"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Upgrade
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFB388EB),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        context.pushNamed("subscriptions");
                      },
                      child: const Text("Nâng cấp"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    final isBlocked = user.isLoading || !user.hasActiveSubscription;

    return GestureDetector(
      onTap: () {
        if (isBlocked) {
          _showUpsell(context);
          return;
        }
        onAllowedTap?.call();
      },
      child: Opacity(opacity: (blockUI && isBlocked) ? 0.5 : 1, child: child),
    );
  }
}
