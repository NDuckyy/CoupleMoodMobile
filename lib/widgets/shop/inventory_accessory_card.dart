import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_mood_mobile/models/venue/member_accessory.dart';
import 'package:flutter/material.dart';

class InventoryAccessoryCard extends StatelessWidget {
  final MemberAccessory item;
  final bool isPreviewing;
  final VoidCallback onTryToggle;
  final VoidCallback onEquipToggle;

  const InventoryAccessoryCard({
    super.key,
    required this.item,
    required this.isPreviewing,
    required this.onTryToggle,
    required this.onEquipToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEquipped = item.isEquipped == true;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            /// ===== Thumbnail (GIỮ Y CHANG SHOP) =====
            GestureDetector(
              onTap: () {
                if (item.thumbnailUrl != null &&
                    item.thumbnailUrl!.trim().isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: InteractiveViewer(
                          child: CachedNetworkImage(
                            imageUrl: item.thumbnailUrl!,
                            fit: BoxFit.contain,
                            placeholder: (_, __) => const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (_, __, ___) => const SizedBox(
                              height: 200,
                              child: Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: item.thumbnailUrl ?? '',
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  memCacheWidth: 150,
                  placeholder: (_, __) => Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// ===== INFO (BỎ PRICE) =====
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 12),

            /// ===== BUTTONS (CLONE 100%) =====
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TRY BUTTON (GIỐNG SHOP)
                OutlinedButton(
                  onPressed: onTryToggle,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF4E9E),
                    side: const BorderSide(
                      color: Color(0xFFFF4E9E),
                      width: 1.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPreviewing
                            ? Icons.visibility_off
                            : Icons.visibility_rounded,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(isPreviewing ? "Bỏ thử" : "Thử"),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// EQUIP / UNEQUIP (CLONE ANIMATION)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  child: GestureDetector(
                    key: ValueKey<bool>(isEquipped),
                    onTap: onEquipToggle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: isEquipped
                            ? const Color(0xFF9E9E9E)
                            : const Color(0xFFFF4E9E),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: isEquipped
                            ? []
                            : [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF4E9E,
                                  ).withOpacity(0.28),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isEquipped
                                ? Icons.remove_circle_outline_rounded
                                : Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 9),
                          Text(
                            isEquipped ? "Tháo" : "Trang bị",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
