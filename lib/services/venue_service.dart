import 'package:couple_mood_mobile/models/venue_model.dart';

import 'api_client.dart';

class VenueService {
  static Future<Venue> getVenueDetail(int id) async {
    final res = await ApiClient.request(
      '/VenueLocation/$id',
      method: HttpMethod.get,
    );

    final root = (res as Map).cast<String, dynamic>();

    if (root['code'] != 200) {
      throw Exception(root['message']?.toString() ?? 'Lỗi lấy venue');
    }

    final data = (root['data'] as Map).cast<String, dynamic>();
    return Venue.fromJson(data);
  }
}
