import 'package:url_launcher/url_launcher_string.dart';

void launchURL(url) async {
  if (!await launchUrlString(url)) throw 'Could not launch $url';
}
