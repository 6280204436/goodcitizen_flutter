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
import '../../../services/native_ios_service.dart';
import '../../location_provider/current_location_provider.dart';
import '../models/auth_request_model.dart';
import '../models/data_model/user_model.dart';
import '../models/response_models/user_response_model.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();

  late Rx<Country> selectedCountry;

  late TextEditingController emailController;
  late FocusNode emailFocusNode;

  late TextEditingController passwordController;
  late FocusNode passwordFocusNode;
  RxBool AgreeConditions = false.obs;
  RxBool isShow = false.obs;
  UserResponseModel? userResponseModel;
  Rxn<CommonItemModel> tempSelectedLanguage = Rxn();
  final nativeIOSService = Get.put(NativeIOSService());
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
    // _setLanguage();
    super.onReady();
  }

  void _setLanguage() {
    // tempSelectedLanguage.value = getSelectedLanguage();
  }

  void changeLanguage() async {
    if (tempSelectedLanguage.value != null) {
      Get.back();
      MyLocaleController.changeLocale(tempSelectedLanguage.value);
    }
  }

  void validate() async {
    if (loginFormKey.currentState!.validate()) {
      if (AgreeConditions.value == false) {
        showSnackBar(
            message:
                "Please Accept Terms And Conditions,EULA & Privacy Policy");
        return;
      }
      customLoader.show(Get.context);
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      String? token = await messaging.getToken();
      Position? position = await getCurrentLocation();
      if (position != null) {
        print(
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}");
        Map<String, dynamic> requestModel = AuthRequestModel.LoginRequestModel(
            email: emailController.text,
            password: passwordController.text,
            lat: position.latitude.toString(),
            long: position.longitude.toString(),
            fcmToken: token);

        _handleSubmit(requestModel);
      } else {
        customLoader.hide();
        showSnackBar(
            message:
                "Location permissions are denied or location services are off.");
        checkLocation();
      }
    }
  }

  Future<void> checkLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are off.");
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
      }
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
    repository.registerApiCall(dataBody: data).then((value) async {
      if (value != null) {
        userResponseModel = value;
        if (userResponseModel?.data?.accessToken != null) {
          preferenceManager.saveAuthToken(userResponseModel?.data?.accessToken);
          await Future.delayed(Duration(milliseconds: 500));
          if (userResponseModel?.data?.role == "USER") {
            final success = await nativeIOSService
                .setAuthToken(userResponseModel?.data?.accessToken ?? "");
            if (success) {
              print(
                  '✅ Auth token initialized: ${userResponseModel?.data?.accessToken}');
            } else {
              print('⚠️ Failed to set auth token, retrying...');
            }
          }
        }
        if (userResponseModel?.data?.role == "USER") {
          currentLocationProvider = Get.put(CurrentLocationProvider());
          currentLocationProvider.startLiveTracking();
        }

        _onSuccess();
        customLoader.hide();
      }
    }).onError((er, stackTrace) {
      print("$er");
      showSnackBar(message: "$er");

      customLoader.hide();
    });
  }

  void _onSuccess() {
    _saveData(userResponseModel);
    if (userResponseModel?.data?.isEmailVerified != true) {
      Get.toNamed(AppRoutes.otpVerifyRoute,
          arguments: {"from": "Signup", "email": emailController.text});
    } else {
      if (userResponseModel?.data?.role == "USER") {
        Get.offAllNamed(AppRoutes.homeRouteUser);
      } else {
        Get.offAllNamed(AppRoutes.homeRoute);
      }
    }
  }

  void _saveData(UserResponseModel? userResponseModel) {
    // if (userResponseModel?.accessToken != null) {
    //   preferenceManager.saveAuthToken(userResponseModel?.accessToken);
    // }
    // if (userResponseModel?.data != null) {
    //   preferenceManager.saveRegisterData(userResponseModel?.data);
    // }
  }

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
    // emailController.dispose();
    // emailFocusNode.dispose();
    //
    // passwordController.dispose();
    // passwordFocusNode.dispose();
  }
}

void showAccountDeactivated(String? title, String? description,
    {String? reason}) {
  if (reason != null) {
    reason =
        '${description?.tr ?? keyAccDeletedDes.tr}\n${keyReason.tr} $reason';
  }
  showAlertDialog(
      title: title ?? keyAccDeactivated.tr,
      buttonText: keyContAdmin.tr,
      onTap: () {
        Get.back();
        Get.toNamed(AppRoutes.supportRoute);
      },
      subtitle: reason ?? description ?? keyAccDeletedDes.tr);
}
