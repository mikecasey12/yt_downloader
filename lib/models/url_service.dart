import 'package:url_launcher/url_launcher.dart';

class UrlService {
  final Uri _uri = Uri.parse('https://youtube.com');
  Future<void> launchUri() async {
    if (!await launchUrl(_uri)) {
      throw Exception('Could not launch $_uri');
    }
  }
}
