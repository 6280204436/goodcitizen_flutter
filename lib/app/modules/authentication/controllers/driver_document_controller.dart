import 'package:file_picker/file_picker.dart';
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

class DriverDocumentController extends GetxController {
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
  Rx<MediaFile> imageBackAdhar = MediaFile().obs;
  var selectedPdfFile = Rxn<File>();
  Rx<MediaFile> imageLicenceFont = MediaFile().obs;
  Rx<MediaFile> imageLicenceBack = MediaFile().obs;
  RxBool isImageTaken = false.obs;
  late TextEditingController passwordController;
  late FocusNode passwordFocusNode;
  late TextEditingController confimPasswordController;
  late FocusNode confirmFocusNode;

  FocusNode countryFocusNode = FocusNode();
  RxBool isShow = false.obs;
  RxBool isShowpass = false.obs;
  SignupModel? userResponseModel;
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

  Future<void> pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Restrict to PDF files
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        selectedPdfFile.value = File(result.files.single.path!);
        confimPasswordController.text = result.files.single.name; // Set file name in text field
      }
    } catch (e) {
      print("Error picking PDF file: $e");
    }
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



  void _setLanguage() {
    // tempSelectedLanguage.value = getSelectedLanguage();
  }

  void changeLanguage() async {
    if (tempSelectedLanguage.value != null) {
      Get.back();
      MyLocaleController.changeLocale(tempSelectedLanguage.value);
    }

  }

  void pickfrontAdhar() {
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

  void pickfrontlicence() {
    showMediaPickerDialog(
      allowVideo: false,
      pickImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.gallery);
        if (file != null) {

          imageLicenceFont.value = MediaFile(localPath: file.path);
          isImageTaken.value = true;

        }
      },
      takeImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.camera);
        if (file != null) {

          imageLicenceFont.value = MediaFile(localPath: file.path);
          isImageTaken.value = true;

        }
      },
    );
  }

  void pickbacklicence() {
    showMediaPickerDialog(
      allowVideo: false,
      pickImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.gallery);
        if (file != null) {

          imageLicenceBack.value = MediaFile(localPath: file.path);
          isImageTaken.value = true;

        }
      },
      takeImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.camera);
        if (file != null) {

          imageLicenceBack.value = MediaFile(localPath: file.path);
          isImageTaken.value = true;

        }
      },
    );
  }

  void pickbackAdhar() {
    showMediaPickerDialog(
      allowVideo: false,
      pickImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.gallery);
        if (file != null) {
          imageBackAdhar.value = MediaFile(localPath: file.path);
          isImageTaken.value = true;


        }
      },
      takeImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.camera);
        if (file != null) {

          imageBackAdhar.value = MediaFile(localPath: file.path);
          isImageTaken.value = true;

        }
      },
    );
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




  void validate() async {
    if (signupFormKey.currentState!.validate()) {
      try {
        // Upload files and get their names
        final adharFront = await callUploadMedia(File(imageFile.value.localPath ?? ''));
        final adharBack = await callUploadMedia(File(imageBackAdhar.value.localPath ?? ''));
        final dlFront = await callUploadMedia(File(imageLicenceFont.value.localPath ?? ''));
        final dlBack = await callUploadMedia(File(imageLicenceBack.value.localPath ?? ''));
        final pdf = await callUploadMedia(File(selectedPdfFile.value?.path ?? ''));

        // Print file names after successful uploads
        if (adharFront != null) {
          print("Aadhar Front File Name: ${adharFront.file_name}");
        }
        if (adharBack != null) {
          print("Aadhar Back File Name: ${adharBack.file_name}");
        }
        if (dlFront != null) {
          print("Driver's License Front File Name: ${dlFront.file_name}");
        }
        if (dlBack != null) {
          print("Driver's License Back File Name: ${dlBack.file_name}");
        }
        if (pdf != null) {
          print("PDF File Name: ${pdf.file_name}");
        }

        Map<String, dynamic> requestModel = AuthRequestModel.DriverDocuments(
          aadhar_front: adharFront?.file_name,
          aadhar_back: adharBack?.file_name,
          dl_expire_date: firstnameController.text,
          dl_front: dlFront?.file_name,
          dl_back: dlBack?.file_name,
          ambulance_num: numberController.text,
          hospital_doc: pdf?.file_name,
            dl_num: lastnameController.text
        );

        _handleSubmit(requestModel);


      } catch (e) {
        print("Error during file upload: $e");
        showSnackBar(message: "File upload failed: $e");
      }
    } else {
      print("Form validation failed or location permissions are denied.");
      showSnackBar(message: "Please fill all required fields correctly.");
    }
  }


  _handleSubmit(var data) {
    repository.DriverDocumentCall(dataBody: data).then((value) async {
      if (value != null) {
        customLoader.hide();
        Get.toNamed(AppRoutes.homeRoute);
      }
    }).onError((er, stackTrace) {
      print("$er");
      showSnackBar(message:"$er" );
      customLoader.hide();


    });
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
    Get.toNamed(AppRoutes.otpVerifyRoute,arguments: {"from":"Signup","email":emailController.text});
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