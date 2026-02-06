import 'package:good_citizen/app/modules/home_module/controllers/Picup_Controller.dart';

import '../../../export.dart';

class PicupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PicupController>(() => PicupController());
  }
}
