import 'package:get/get.dart';
import 'package:good_citizen/app/modules/profile/controllers/update_document_controller.dart';

import '../controllers/account_info_controller.dart';
import '../controllers/contact_us_controller.dart';
import '../controllers/edit_item_controller.dart';
import '../controllers/my_docs_controller.dart';

class UpdateDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateDocumentController>(() => UpdateDocumentController());

  }
}
