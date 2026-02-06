import 'package:good_citizen/app/modules/authentication/models/response_models/signup_datamodel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:good_citizen/app/core/utils/common_methods.dart';
import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/models/data_model/message_response_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_data.dart';
import '../../../core/utils/common_item_model.dart';
import '../../../core/utils/image_picker.dart';
import '../../../core/utils/localizations/localization_controller.dart';
import '../../../core/widgets/image_picker_dialog.dart';
import '../../../core/widgets/intl_phone_field/countries.dart';
import '../../../core/widgets/intl_phone_field/intl_phone_field.dart';
import '../../../core/widgets/show_dialog.dart';
import '../../model/media_file_model.dart';
import '../models/auth_request_model.dart';
import '../models/data_model/media_upload_model.dart';
import '../models/data_model/user_model.dart';
import '../models/response_models/user_response_model.dart';

class SignUpController extends GetxController {
  final signupFormKey = GlobalKey<FormState>();

  final Rx<Country> selectedCountry = Country(
    name: 'India',
    code: 'IN',
    dialCode: '91',
    flag: '🇮🇳',
    nameTranslations: {'en': 'India'},
    minLength: 10,
    maxLength: 10,
  ).obs;

  late TextEditingController emailController;
  late FocusNode emailFocusNode;
  Rx<MediaFile> imageFile = MediaFile().obs;
  RxBool isImageTaken = false.obs;
  late TextEditingController passwordController;
  late FocusNode passwordFocusNode;
  late TextEditingController confimPasswordController;
  late FocusNode confirmFocusNode;
  RxString gender = ''.obs;
  FocusNode countryFocusNode = FocusNode();
  RxBool isShow = false.obs;
  RxBool AgreeConditions = false.obs;
  RxBool isShowpass = false.obs;
  SignupModel? userResponseModel;
  MediaUploadResponseModel? mediaUploadResponseModel;
  Rxn<CommonItemModel> tempSelectedLanguage = Rxn();
  late TextEditingController firstnameController;
  late FocusNode firstnameNode;
  late TextEditingController lastnameController;
  late FocusNode lastnameNode;
  late TextEditingController numberController = TextEditingController();
  late FocusNode phoneNode;
  final GlobalKey<IntlPhoneFieldState> countryPickerKey =
      GlobalKey<IntlPhoneFieldState>();
  @override
  void onInit() {
    _initControllers();
    // _loadCountry();
    super.onInit();
  }

  // void _loadCountry() {
  //   final country = getSelectedCountryCode();
  //   selectedCountry = country.obs;
  // }

  @override
  void onReady() {
    // _setLanguage();
    super.onReady();
  }

  Future<MediaUploadResponseModel?> callUploadMedia(File file,
      {bool showLoader = true}) async {
    // isUploadingImage.value = true;
    return await repository
        .mediaUploadApiCall(file, showLoader: showLoader)
        .then((value) {
      if (value != null) {
        MediaUploadResponseModel responseModel = value;
        return responseModel;
      }
    }).onError((error, stackTrace) {
      showSnackBar(message: error.toString());
      return null;
    });
  }

  void changeLanguage() async {
    if (tempSelectedLanguage.value != null) {
      Get.back();
      MyLocaleController.changeLocale(tempSelectedLanguage.value);
    }
  }

  void pickImage() {
    showMediaPickerDialog(
      allowVideo: false,
      pickImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.gallery);
        if (file != null) {
          imageFile.value = MediaFile(localPath: file.path);
          isImageTaken.value = true;
        }
      },
      takeImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.camera);
        if (file != null) {
          imageFile.value = MediaFile(localPath: file.path);
          isImageTaken.value = true;
        }
      },
    );
  }

  void validate() async {
    if (signupFormKey.currentState!.validate()) {
      // customLoader.show(Get.context);
      if (AgreeConditions.value == false) {
        showSnackBar(
            message:
                "Please Accept Terms And Conditions,EULA & Privacy Policy");
        return;
      }
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      String? token = await messaging.getToken();
      Position? position = await getCurrentLocation();

      final path =
          (await callUploadMedia(File(imageFile.value.localPath ?? '')))
              ?.file_name;

      if (position != null) {
        print(
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}");
        Map<String, dynamic> requestModel =
            AuthRequestModel.socialLoginRequestModel(
                first_name: firstnameController.text,
                last_name: lastnameController.text,
                country_code: selectedCountry.value.dialCode,
                phone_number: numberController.text,
                email: emailController.text,
                password: confimPasswordController.text,
                lat: position.latitude.toString(),
                profile_pic: path,
                gender: gender.value?.toUpperCase() ?? "",
                long: position.longitude.toString(),
                role: Get.arguments['role'] == "user".toUpperCase()
                    ? "USER"
                    : "DRIVER",
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

  _handleSubmit(var data) {
    try {
      customLoader.hide();
      repository.signupApiCall(dataBody: data).then((value) async {
        if (value != null) {
          userResponseModel = value;
          if (userResponseModel?.accessToken != null) {
            preferenceManager.saveAuthToken(userResponseModel?.accessToken);
          }
          _onSuccess();
          customLoader.hide();
        }
      }).onError((er, stackTrace) {
        print("$er");
        showSnackBar(message: "$er");
        customLoader.hide();
      });
    } catch (er) {
      print("$er");
      showSnackBar(message: "$er");
      customLoader.hide();
    } finally {
      customLoader.hide();
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

  void _onSuccess() {
    Get.toNamed(AppRoutes.otpVerifyRoute,
        arguments: {"from": "Signup", "email": emailController.text});
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

    numberController = TextEditingController();
    phoneNode = FocusNode();
    passwordController = TextEditingController();
    passwordFocusNode = FocusNode();
    confimPasswordController = TextEditingController();
    confirmFocusNode = FocusNode();
    lastnameController = TextEditingController();
    lastnameNode = FocusNode();
    firstnameController = TextEditingController();
    firstnameNode = FocusNode();
    countryFocusNode = FocusNode();
  }

  void _disposeControllers() {
    emailController.dispose();
    emailFocusNode.dispose();
    lastnameController.dispose();
    lastnameNode.dispose();
    firstnameController.dispose();
    firstnameNode.dispose();
    countryFocusNode.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    numberController.dispose();
    phoneNode.dispose();

    confimPasswordController.dispose();
    confirmFocusNode.dispose();
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
