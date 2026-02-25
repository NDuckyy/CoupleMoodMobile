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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  bool _isSelectionMode = false;
  final Set<int> _selectedVenueIds = {};

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CollectionDetailProvider>();
    final listProvider = context.watch<CollectionProvider>();
    final CollectionItem? collection = provider.collection;

    final filteredVenues = collection == null
        ? []
        : collection.venues.where((venue) {
            final query = _searchQuery.toLowerCase();
            return venue.name.toLowerCase().contains(query) ||
                venue.address.toLowerCase().contains(query);
          }).toList();

    final isDefault =
        collection != null && listProvider.defaultCollectionId == collection.id;

    return Scaffold(
      bottomNavigationBar: collection == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: isDefault
                        ? null
                        : () async {
                            final result = await context.pushNamed(
                              'add_venue_to_collection',
                              extra: {
                                'collectionId': collection.id,
                                'existingIds': collection.venues
                                    .map((e) => e.id)
                                    .toList(),
                              },
                            );

                            if (result == true) {
                              if (!mounted) return;

                              context
                                  .read<CollectionDetailProvider>()
                                  .getCollectionDetail(collection.id);
                            }
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
            ),
      resizeToAvoidBottomInset: true,
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
                  onEdit: isDefault
                      ? null
                      : () async {
                          final result = await context.pushNamed(
                            'edit_collection',
                            extra: {'collection': collection},
                          );

                          if (result == true) {
                            context
                                .read<CollectionDetailProvider>()
                                .getCollectionDetail(widget.collectionId);

                            context
                                .read<CollectionProvider>()
                                .getMyCollections();
                          }
                        },

                  onShare: () => debugPrint('Share'),

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
                                    onPressed: () => context.pop(false),
                                    child: const Text("Huỷ"),
                                  ),
                                  TextButton(
                                    onPressed: () => context.pop(true),
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
                                  .deleteCollection(collection!.id);

                              if (mounted) context.pop(true);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm địa điểm...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_isSelectionMode)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_selectedVenueIds.length} đã chọn'),
                        TextButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Xoá các địa điểm"),
                                content: const Text(
                                  "Bạn có chắc muốn xoá các địa điểm đã chọn?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => context.pop(false),
                                    child: const Text("Huỷ"),
                                  ),
                                  TextButton(
                                    onPressed: () => context.pop(true),
                                    child: const Text(
                                      "Xoá",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                await context
                                    .read<CollectionProvider>()
                                    .removeVenues(
                                      collectionId: collection!.id,
                                      venueIds: _selectedVenueIds.toList(),
                                    );

                                await context
                                    .read<CollectionDetailProvider>()
                                    .getCollectionDetail(collection.id);

                                setState(() {
                                  _isSelectionMode = false;
                                  _selectedVenueIds.clear();
                                });

                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Đã xoá các địa điểm đã chọn",
                                    ),
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Xoá tất cả",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        MediaQuery.of(context).viewInsets.bottom + 16,
                      ),
                      itemCount: filteredVenues.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final venue = filteredVenues[index];

                        final isSelected = _selectedVenueIds.contains(venue.id);

                        return GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _isSelectionMode = true;
                              _selectedVenueIds.add(venue.id);
                            });
                          },
                          onTap: _isSelectionMode
                              ? () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedVenueIds.remove(venue.id);
                                    } else {
                                      _selectedVenueIds.add(venue.id);
                                    }

                                    if (_selectedVenueIds.isEmpty) {
                                      _isSelectionMode = false;
                                    }
                                  });
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected
                                  ? Colors.pinkAccent.withOpacity(0.08)
                                  : Colors.transparent,
                            ),
                            child: Stack(
                              children: [
                                CollectionVenueItem(
                                  venue: venue,
                                  onRemove: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
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
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      try {
                                        await context
                                            .read<CollectionProvider>()
                                            .removeVenue(
                                              collectionId: collection!.id,
                                              venueId: venue.id,
                                            );

                                        await context
                                            .read<CollectionDetailProvider>()
                                            .getCollectionDetail(collection.id);

                                        if (!mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Đã xoá '${venue.name}' khỏi bộ sưu tập",
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        if (!mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }
                                    }
                                  },
                                ),

                                if (_isSelectionMode)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Checkbox(
                                        value: isSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              _selectedVenueIds.add(venue.id);
                                            } else {
                                              _selectedVenueIds.remove(
                                                venue.id,
                                              );
                                            }

                                            if (_selectedVenueIds.isEmpty) {
                                              _isSelectionMode = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
