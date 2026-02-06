import 'package:url_launcher/url_launcher.dart';

import '../../../export.dart';

void openMap(var lat, var long) async {
  String appleUrl =
      'https://maps.apple.com/?saddr=&daddr=$lat,$long&directionsmode=driving';
  String googleUrl =
      'http://www.google.com/maps/dir/?api=1&travelmode=driving&destination=$lat,$long';

  Uri appleUri = Uri.parse(appleUrl);
  Uri googleUri = Uri.parse(googleUrl);

  if (Platform.isIOS) {
    if (await canLaunchUrl(appleUri)) {
      await launchUrl(appleUri, mode: LaunchMode.externalApplication);
    } else {
      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
      }
    }
  } else {
    if (await canLaunchUrl(googleUri)) {
      await launchUrl(googleUri, mode: LaunchMode.externalApplication);
    }
  }
}