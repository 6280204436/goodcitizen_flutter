import 'package:get/get.dart';

import 'languages/english.dart';
import 'languages/hindi.dart';

class LanguageTranslations extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US':english,
    'hi_IN':hindi,
  };

}