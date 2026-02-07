import 'package:couple_mood_mobile/models/api_response.dart';
import 'package:couple_mood_mobile/models/venue_model.dart';

import 'api_client.dart';

class VenueService {
  static Future<ApiResponse<Venue>> getVenueDetail(int id) async {
    final res = await ApiClient.request(
      '/VenueLocation/$id',
      method: HttpMethod.get,
    );

    return ApiResponse<Venue>.fromJson(
      res as Map<String, dynamic>,
      (json) => Venue.fromJson(json as Map<String, dynamic>),
    );
  }
}
