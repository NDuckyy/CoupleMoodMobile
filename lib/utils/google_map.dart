import 'package:url_launcher/url_launcher.dart';

Future<void> openMap(double lat, double lng, String name) async {
  final Uri url = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(name)}&query_place_id=$lat,$lng',
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Không mở được Google Maps';
  }
}
