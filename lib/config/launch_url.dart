import 'package:url_launcher/url_launcher.dart';

void launchUrlHelper(String? url) async {
  if (url == null) return;
  final uri = Uri.parse(url);
  final canLaunch = await canLaunchUrl(uri);
  if (canLaunch) {
    await launchUrl(uri);
  }
}
