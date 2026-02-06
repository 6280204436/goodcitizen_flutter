import 'package:good_citizen/app/modules/home_module/controllers/home_controller.dart';
import 'package:good_citizen/app/modules/home_module/controllers/home_user_controller.dart';

import '../../../export.dart';

class HomeUserBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeUserController>(() => HomeUserController());
  }
}
