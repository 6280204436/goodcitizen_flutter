
import 'package:good_citizen/app/export.dart';



class OnBordingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnBoardingController>(
          () => OnBoardingController(),
    );


  }
}
