import 'package:good_citizen/app/modules/home_module/controllers/home_controller.dart';

import '../../../export.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
