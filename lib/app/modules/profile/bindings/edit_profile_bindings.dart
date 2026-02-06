import 'package:get/get.dart';

import '../controllers/account_info_controller.dart';
import '../controllers/contact_us_controller.dart';
import '../controllers/edit_item_controller.dart';
import '../controllers/my_docs_controller.dart';

class EditProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditItemController>(() => EditItemController());

  }
}
