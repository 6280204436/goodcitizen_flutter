import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../common_item_model.dart';

class MyLocaleController {
  static Future changeLocale(CommonItemModel? language) async {
    if (language != null) {
      selectedLanguage.value = language;
      final Locale locale = Locale(language.id ?? '');
      deviceLocale = locale;
      await Get.updateLocale(locale);
      // preferenceManager.saveLanguage(locale.localeIdentifier);
    }
  }
}
