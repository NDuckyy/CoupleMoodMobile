import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        title: const Text('Danh sách bộ sưu tập'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // _SearchAndFilter(),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.collections.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.78,
                        ),
                    itemBuilder: (context, index) {
                      /// Add new collection card
                      if (index == provider.collections.length) {
                        return AddCollectionCard();
                      }

                      final collection = provider.collections[index];

                      return CollectionCard(
                        collection: collection,
                        onEdit: () {
                          debugPrint('Edit ${collection.id}');
                        },
                        onShare: () {
                          debugPrint('Share ${collection.id}');
                        },
                        onDelete: () {
                          debugPrint('Delete ${collection.id}');
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
