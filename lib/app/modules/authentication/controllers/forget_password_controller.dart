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

class ForgetPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Rx<Country> selectedCountry;

  late TextEditingController emailController;
  late FocusNode emailFocusNode;

  late TextEditingController passwordController;
  late FocusNode passwordFocusNode;


  ForgetPasswordResponseModel? forgetPasswordResponseModel;
  Rxn<CommonItemModel> tempSelectedLanguage = Rxn();

  @override
  void onInit() {
    _initControllers();
    // _loadCountry();
    super.onInit();
  }

  void _loadCountry() {
    final country = getSelectedCountryCode();
    selectedCountry = country.obs;
  }

  @override
  void onReady() {

    super.onReady();
  }




  void validate() async {
    if (formKey.currentState!.validate()) {
        Map<String, dynamic> requestModel = AuthRequestModel.forgePassRequestModel(
            email: emailController.text,
        );
        _handleSubmit(requestModel);





    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, request user to enable it
      return null;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, user needs to enable it manually
      return null;
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  _handleSubmit(var data) {
    repository.forgetPasswordApiCall(dataBody: data).then((value) async {
      if (value != null) {
        forgetPasswordResponseModel=value;
        showSnackBar(message:forgetPasswordResponseModel?.message??"" );
        Get.offNamed(AppRoutes.otpVerifyRoute,arguments: {"email":emailController.text,"from":"other"});
      }
    }).onError((er, stackTrace) {
      print("$er");
      showSnackBar(message:"$er" );


    });
  }

  void _onSuccess() {

    Get.toNamed(AppRoutes.homeRoute);
  }

  // void _saveData(UserResponseModel? userResponseModel) {
  //   if (userResponseModel?.data?.accessToken != null) {
  //     preferenceManager.saveAuthToken(userResponseModel?.data?.accessToken );
  //   }
  //
  // }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initControllers() {
    emailController = TextEditingController();
    emailFocusNode = FocusNode();

    passwordController = TextEditingController();
    passwordFocusNode = FocusNode();
  }

  void _disposeControllers() {
    emailController.dispose();
    emailFocusNode.dispose();

    passwordController.dispose();
    passwordFocusNode.dispose();
  }
}

