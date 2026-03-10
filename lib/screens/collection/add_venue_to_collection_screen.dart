import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:couple_mood_mobile/providers/collection/collection_provider.dart';
import 'package:couple_mood_mobile/widgets/snack_bar.dart';

class AddVenueToCollectionScreen extends StatefulWidget {
  final int collectionId;
  final List<int> existingVenueIds;
  final String? collectionName;

  const AddVenueToCollectionScreen({
    super.key,
    required this.collectionId,
    required this.existingVenueIds,
    this.collectionName,
  });

  @override
  State<AddVenueToCollectionScreen> createState() =>
      _AddVenueToCollectionScreenState();
}

class _AddVenueToCollectionScreenState
    extends State<AddVenueToCollectionScreen> {
  final Set<int> selectedIds = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<CollectionProvider>().getCurrentCollection();
    });
  }

  Future<void> _handleAdd() async {
    try {
      await context.read<CollectionProvider>().addVenuesToCollection(
        collectionId: widget.collectionId,
        venueIds: selectedIds.toList(),
      );

      if (!mounted) return;

      showMsg(
        context,
        "Bạn đã thêm ${selectedIds.length} địa điểm vào \"${widget.collectionName ?? 'bộ sưu tập'}\"",
        true,
      );

      await Future.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      showMsg(context, e.toString(), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CollectionProvider>();
    final defaultCollection = provider.currentCollection;

    final allVenues =
        defaultCollection?.venues
            .where((v) => !widget.existingVenueIds.contains(v.id))
            .toList() ??
        [];

    final venues = allVenues.where((v) {
      final query = _searchQuery.toLowerCase();
      return v.name.toLowerCase().contains(query) ||
          v.address.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Chọn địa điểm"), centerTitle: true),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                /// SEARCH
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm địa điểm...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                if (venues.isEmpty)
                  const Expanded(
                    child: Center(child: Text("Không có địa điểm phù hợp")),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: venues.length,
                      itemBuilder: (context, index) {
                        final venue = venues[index];
                        final isSelected = selectedIds.contains(venue.id);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedIds.remove(venue.id);
                              } else {
                                selectedIds.add(venue.id);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.pink.shade50
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.pinkAccent
                                    : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child:
                                      venue.coverImage != null &&
                                          venue.coverImage!.isNotEmpty
                                      ? Image.network(
                                          venue.coverImage!,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Image.asset(
                                            'lib/assets/images/venue_placeholder.png',
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          'lib/assets/images/venue_placeholder.png',
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        venue.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        venue.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Checkbox(
                                  value: isSelected,
                                  activeColor: Colors.pinkAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  onChanged: (_) {
                                    setState(() {
                                      if (isSelected) {
                                        selectedIds.remove(venue.id);
                                      } else {
                                        selectedIds.add(venue.id);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                /// BUTTON
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: selectedIds.isEmpty ? null : _handleAdd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          selectedIds.isEmpty
                              ? "Chọn địa điểm"
                              : "Thêm ${selectedIds.length} địa điểm",
                          key: ValueKey(selectedIds.length),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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
