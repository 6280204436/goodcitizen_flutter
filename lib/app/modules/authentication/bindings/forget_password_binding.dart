import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/controllers/add_user_details_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/forget_password_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/login_controller.dart';
import 'package:good_citizen/app/modules/authentication/controllers/select_signup_controller.dart';

import '../controllers/otp_verify_controller.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController());

  }
}
