import 'package:couple_mood_mobile/providers/recommendation_provider.dart';
import 'package:couple_mood_mobile/screens/location/widget/category_card.dart';
import 'package:couple_mood_mobile/screens/location/widget/price_range.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FilterLocationScreen extends StatefulWidget {
  const FilterLocationScreen({super.key});

  @override
  State<FilterLocationScreen> createState() => _FilterLocationScreenState();
}

class _FilterLocationScreenState extends State<FilterLocationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<RecommendationProvider>().fetchAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecommendationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FF),
      appBar: AppBar(
        title: const Text(
          "Filter địa điểm",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              debugPrint("Selected category: ${provider.selectedCategory?.name}");
              debugPrint(
                "Selected price range: ${provider.priceRange.start} - ${provider.priceRange.end}",
              );
              context.pop(true);
            },
            child: const Text("Áp dụng"),
          ),
        ],
      ),
      body: provider.isCategoryLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearch(provider),
                PriceRangeFilter(
                  values: provider.priceRange,
                  min: 0,
                  max: 1000000,
                  onChanged: provider.updatePrice,
                ),
                Expanded(child: _buildGrid(provider)),
              ],
            ),
    );
  }

  Widget _buildSearch(RecommendationProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: TextField(
          onChanged: provider.searchCategory,
          decoration: const InputDecoration(
            hintText: "Tìm địa điểm bạn thích...",
            prefixIcon: Icon(Icons.search, color: Color(0xFFB388EB)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(RecommendationProvider provider) {
    final list = provider.filteredCategories;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.6,
      ),
      itemBuilder: (context, index) {
        final category = list[index];
        final selected = provider.selectedCategory;

        return CategoryCard(
          name: category.name,
          isSelected: selected?.id == category.id,
          onTap: () {
            provider.selectCategory(category);
          },
        );
      },
    );
  }
}
