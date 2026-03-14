import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/collection/collection_item_summary.dart';
import 'package:couple_mood_mobile/models/venue/venue_model.dart';
import 'package:couple_mood_mobile/models/collection/collection_item.dart';
import 'package:couple_mood_mobile/services/venue/venue_service.dart';
import 'package:couple_mood_mobile/services/collection/collection_service.dart';
import 'package:flutter/material.dart';

class VenueDetailProvider extends ChangeNotifier {
  ApiResponse<Venue>? venueResponse;

  bool loading = false;
  bool favoriteLoading = false;
  String? error;

  bool isFavorite = false;
  int favoriteCount = 0;

  CollectionItem? _currentCollection;

  Venue? get venue => venueResponse?.data;

  List<CollectionItemSummary> collections = [];

  /// ================= LOAD VENUE =================
  Future<void> loadVenue(int id) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      venueResponse = await VenueService.getVenueDetail(id);

      if (venueResponse!.code != 200 || venueResponse!.data == null) {
        error = venueResponse!.message;
      } else {
        favoriteCount = venue?.favoriteCount ?? 0;

        //  Load current collection
        final currentRes = await CollectionService.getCurrentCollection();

        _currentCollection = currentRes.data;

        //  Check venue có nằm trong collection không
        isFavorite =
            _currentCollection?.venues.any((v) => v.id == venue!.id) ?? false;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleFavorite() async {
    if (venue == null || _currentCollection == null) return false;
    if (favoriteLoading) return false;

    favoriteLoading = true;
    notifyListeners();

    final oldValue = isFavorite;

    try {
      if (!isFavorite) {
        await CollectionService.addVenueToCollection(
          collectionId: _currentCollection!.id,
          venueId: venue!.id,
        );
      } else {
        await CollectionService.removeVenuesFromCollection(
          collectionId: _currentCollection!.id,
          venueIds: [venue!.id],
        );
      }

      //  Reload current collection để sync đúng type
      final currentRes = await CollectionService.getCurrentCollection();

      _currentCollection = currentRes.data;

      isFavorite =
          _currentCollection?.venues.any((v) => v.id == venue!.id) ?? false;

      favoriteCount += isFavorite ? 1 : -1;

      notifyListeners();
      return true;
    } catch (e) {
      isFavorite = oldValue;
      notifyListeners();
      return false;
    } finally {
      favoriteLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCollectionSummaries() async {
    final res = await CollectionService.getCollectionSummaries();

    if (res.code == 200 && res.data != null) {
      collections = res.data!;
    }
  }

  Future<void> addVenueToOtherCollection(int collectionId) async {
    if (venue == null) return;

    await CollectionService.addVenueToCollection(
      collectionId: collectionId,
      venueId: venue!.id,
    );
  }
}
