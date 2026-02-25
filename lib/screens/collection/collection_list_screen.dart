import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:couple_mood_mobile/providers/collection/collection_provider.dart';
import 'package:couple_mood_mobile/widgets/collection/collection_card.dart';
import 'package:couple_mood_mobile/widgets/collection/add_collection_card.dart';

class CollectionListScreen extends StatefulWidget {
  const CollectionListScreen({super.key});

  @override
  State<CollectionListScreen> createState() => _CollectionListScreenState();
}

class _CollectionListScreenState extends State<CollectionListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CollectionProvider>().getMyCollections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CollectionProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed("home");
            }
          },
        ),
        title: const Text('Danh sách bộ sưu tập'),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.collections.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                if (index == provider.collections.length) {
                  return const AddCollectionCard();
                }

                final collection = provider.collections[index];

                ///  CHECK DEFAULT COLLECTION
                final isDefault = provider.defaultCollectionId == collection.id;

                return CollectionCard(
                  collection: collection,

                  onTap: () async {
                    final result = await context.pushNamed(
                      'collection_detail',
                      extra: {'collectionId': collection.id},
                    );

                    if (result == true) {
                      context.read<CollectionProvider>().getMyCollections();
                    }
                  },

                  ///  Nếu là default thì disable edit
                  onEdit: isDefault
                      ? null
                      : () async {
                          final result = await context.pushNamed(
                            'edit_collection',
                            extra: {'collection': collection},
                          );

                          if (result == true) {
                            context
                                .read<CollectionProvider>()
                                .getMyCollections();
                          }
                        },

                  onShare: () {
                    debugPrint('Share ${collection.id}');
                  },

                  ///  Nếu là default thì disable delete
                  onDelete: isDefault
                      ? null
                      : () async {
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
                                  .read<CollectionProvider>()
                                  .deleteCollection(collection.id);
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
    );
  }
}
