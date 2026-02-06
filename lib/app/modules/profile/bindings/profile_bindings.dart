import 'package:good_citizen/app/modules/profile/controllers/account_detail_controller.dart';
import 'package:good_citizen/app/modules/profile/controllers/currency_language_controller.dart';
import 'package:good_citizen/app/modules/profile/controllers/faq_controller.dart';
import 'package:good_citizen/app/modules/profile/controllers/profile_controller.dart';
import 'package:good_citizen/app/modules/profile/controllers/reviews_list_controller.dart';
import 'package:good_citizen/app/modules/profile/controllers/static_page_controller.dart';

import 'package:get/get.dart';

import '../controllers/account_info_controller.dart';
import '../controllers/contact_us_controller.dart';
import '../controllers/edit_item_controller.dart';
import '../controllers/my_docs_controller.dart';
import '../controllers/my_document_view_controller.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountInfoController>(() => AccountInfoController());
    Get.lazyPut<AccountDetailController>(() => AccountDetailController());
    // Get.lazyPut<MyDocsController>(() => MyDocsController());

    Get.lazyPut<ProfileController>(() => ProfileController());
    // Get.lazyPut<CurrencyLanguageController>(() => CurrencyLanguageController());

    Get.lazyPut<MyDocumentViewController>(() => MyDocumentViewController());

    Get.lazyPut<FaqController>(() => FaqController());
    Get.lazyPut<ContactUsController>(() => ContactUsController());
    Get.lazyPut<StaticPageController>(() => StaticPageController());
    Get.lazyPut<ReviewsListController>(() => ReviewsListController());
  }
}
