import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:couple_mood_mobile/providers/collection/collection_detail_provider.dart';
import 'package:couple_mood_mobile/providers/collection/collection_provider.dart';
import 'package:couple_mood_mobile/models/collection/collection_item.dart';
import 'package:couple_mood_mobile/widgets/collection/collection_header.dart';
import 'package:couple_mood_mobile/widgets/collection/collection_action_row.dart';
import 'package:couple_mood_mobile/widgets/collection/collection_venue_item.dart';

class CollectionDetailScreen extends StatefulWidget {
  final int collectionId;

  const CollectionDetailScreen({super.key, required this.collectionId});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CollectionDetailProvider>().getCollectionDetail(
        widget.collectionId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CollectionDetailProvider>();
    final CollectionItem? collection = provider.collection;

    return Scaffold(
      appBar: AppBar(
        title: Text(collection?.collectionName ?? ''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop(true);
          },
        ),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : collection == null
          ? const Center(child: Text('Không có dữ liệu'))
          : Column(
              children: [
                CollectionHeader(collection: collection),
                CollectionActionRow(
                  onEdit: () async {
                    final result = await context.pushNamed(
                      'edit_collection',
                      extra: {'collection': collection},
                    );

                    if (result == true) {
                      context
                          .read<CollectionDetailProvider>()
                          .getCollectionDetail(widget.collectionId);

                      context.read<CollectionProvider>().getMyCollections();
                    }
                  },
                  onShare: () => debugPrint('Share'),
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Xoá bộ sưu tập"),
                          content: const Text(
                            "Bạn có chắc muốn xoá bộ sưu tập này?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Huỷ"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                "Xoá",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      try {
                        await context
                            .read<CollectionProvider>()
                            .deleteCollection(collection.id);

                        if (mounted) context.pop(true);
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Địa điểm trong bộ sưu tập',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: collection.venues.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return CollectionVenueItem(
                        venue: collection.venues[index],
                        onRemove: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Xoá địa điểm"),
                                content: const Text(
                                  "Bạn có chắc muốn xoá địa điểm này khỏi bộ sưu tập?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Huỷ"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text(
                                      "Xoá",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            try {
                              await context
                                  .read<CollectionDetailProvider>()
                                  .removeVenue(
                                    collectionId: collection.id,
                                    venueId: collection.venues[index].id,
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Đã xoá địa điểm khỏi bộ sưu tập",
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        debugPrint('Add venue');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm địa điểm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
