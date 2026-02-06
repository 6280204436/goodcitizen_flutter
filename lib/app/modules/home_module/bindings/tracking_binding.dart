import 'package:good_citizen/app/modules/home_module/controllers/home_controller.dart';
import 'package:good_citizen/app/modules/home_module/controllers/tracking_controller.dart';

import '../../../export.dart';

class TrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackingController>(() => TrackingController());
  }
}
