import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void openUrl(BuildContext context, String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not launch $url'),
      ),
    );
  }
}
