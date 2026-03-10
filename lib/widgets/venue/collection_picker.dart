import 'package:couple_mood_mobile/models/collection/collection_item_summary.dart';
import 'package:couple_mood_mobile/providers/venue/venue_detail_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

void showCollectionPicker(
  BuildContext context,
  List<CollectionItemSummary> collections,
  VenueDetailProvider provider,
) {
  final filtered = collections
      .where((c) => c.collectionName != "Mục yêu thích")
      .toList();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            /// Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Lưu vào",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            /// Collections Grid
            GridView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                final collection = filtered[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    Navigator.pop(context);

                    await provider.addVenueToOtherCollection(collection.id);

                    showMsg(
                      context,
                      "Đã thêm vào ${collection.collectionName}",
                      true,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        /// Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child:
                                (collection.img != null &&
                                    collection.img!.isNotEmpty)
                                ? Image.network(
                                    collection.img!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'lib/assets/images/collection_placeholder.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'lib/assets/images/collection_placeholder.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// Name
                        Expanded(
                          child: Text(
                            collection.collectionName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
