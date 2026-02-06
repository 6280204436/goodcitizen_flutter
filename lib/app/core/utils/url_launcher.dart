import 'package:good_citizen/app/data/repository/endpoint.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../export.dart';

class UrlLauncher {
  static void launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  static launchCaller(String? contact) async {



    final url = Uri.parse( Platform.isIOS ?"tel://${contact?.replaceAll('+', '')}":"tel:$contact");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static launch(String? urlData) async {
    if (urlData == null) {
      return;
    }

    final url = Uri.parse(urlData);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}
