import 'package:good_citizen/app/modules/authentication/models/response_models/forget_password_response_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:good_citizen/app/core/utils/common_methods.dart';
import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/models/data_model/message_response_model.dart';
import 'package:geolocator/geolocator.dart';

import '../../../common_data.dart';
import '../../../core/utils/common_item_model.dart';
import '../../../core/utils/localizations/localization_controller.dart';
import '../../../core/widgets/intl_phone_field/countries.dart';
import '../../../core/widgets/show_dialog.dart';
import '../models/auth_request_model.dart';
import '../models/data_model/user_model.dart';
import '../models/response_models/user_response_model.dart';

class PasswordChangeController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Rx<Country> selectedCountry;

  late TextEditingController emailController;
  late FocusNode emailFocusNode;
  RxBool isShow =true.obs;
  RxBool ispassShow =true.obs;
  late TextEditingController passwordController;
  late FocusNode passwordFocusNode;

  late TextEditingController confirmPasswordController;
  late FocusNode confirmPasswordFocusNode;
  ForgetPasswordResponseModel? forgetPasswordResponseModel;
  Rxn<CommonItemModel> tempSelectedLanguage = Rxn();

  @override
  void onInit() {
    _initControllers();
    // _loadCountry();
    super.onInit();
  }



  @override
  void onReady() {

    super.onReady();
  }




  void validate() async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> requestModel = AuthRequestModel.setPasswordRequestModel(
        password: passwordController.text,
      );
      _handleSubmit(requestModel);

print(">>>>>>>>>>>>>>>>${requestModel.values}");



    }
  }



  _handleSubmit(var data) {
    repository.setPasswordApicall(dataBody: data).then((value) async {
      if (value != null) {
        forgetPasswordResponseModel=value;
        showSnackBar(message:forgetPasswordResponseModel?.message??"" );
        Get.offAllNamed(AppRoutes.loginRoute);
      }
    }).onError((er, stackTrace) {
      print("$er");
      showSnackBar(message:"Error:$er" );


    });
  }

  // void _onSuccess() {
  //
  //   Get.toNamed(AppRoutes.homeRoute);
  // }

  void _saveData(UserResponseModel? userResponseModel) {
    if (userResponseModel?.data?.accessToken != null) {
      preferenceManager.saveAuthToken(userResponseModel?.data?.accessToken );
    }

  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initControllers() {
    confirmPasswordController = TextEditingController();
    confirmPasswordFocusNode = FocusNode();

    passwordController = TextEditingController();
    passwordFocusNode = FocusNode();
  }

  void _disposeControllers() {
    confirmPasswordController.dispose();
    confirmPasswordFocusNode.dispose();

    passwordController.dispose();
    passwordFocusNode.dispose();
  }
}

