import 'package:file_picker/file_picker.dart';
import 'package:good_citizen/app/modules/authentication/models/response_models/signup_datamodel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:good_citizen/app/core/utils/common_methods.dart';
import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/models/data_model/message_response_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:good_citizen/app/modules/profile/controllers/profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_data.dart';
import '../../../core/utils/common_item_model.dart';
import '../../../core/utils/image_picker.dart';
import '../../../core/utils/localizations/localization_controller.dart';
import '../../../core/widgets/image_picker_dialog.dart';
import '../../../core/widgets/intl_phone_field/countries.dart';
import '../../../core/widgets/intl_phone_field/intl_phone_field.dart';
import '../../../core/widgets/show_dialog.dart';
import '../../authentication/models/auth_request_model.dart';
import '../../authentication/models/data_model/media_upload_model.dart';
import '../../authentication/models/response_models/user_response_model.dart';
import '../../model/media_file_model.dart';

class UpdateDocumentController extends GetxController {
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
 Rx<UserResponseModel?> userResponseModel = Rx<UserResponseModel?>(null);
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
    loadProfile();
    super.onReady();
  }



  void loadProfile({bool showLoader = true}) {
    if (showLoader) {
      customLoader.show(Get.context);
    }
    repository.getProfileApiCall().then((value) async {

      update();
      if (value != null) {
        userResponseModel.value = value;
        update();

        numberController.text=userResponseModel.value?.data?.ambulanceNum??"";
        firstnameController.text=userResponseModel.value?.data?.dlExpireDate??"";
        confimPasswordController.text=userResponseModel.value?.data?.hospitalDoc??"";
        lastnameController.text=userResponseModel.value?.data?.dl_num??"";



        customLoader.hide();



      }}).onError((error, stackTrace) {

      customLoader.hide();
      update();
      debugPrint('error>>$error');
    });
  }

  void changeLanguage() async {
    if (tempSelectedLanguage.value != null) {
      Get.back();
      MyLocaleController.changeLocale(tempSelectedLanguage.value);
    }

  }


  Future<void> goToWebPage(String urlString) async {
    final Uri _url = Uri.parse(urlString);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
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

        var adharFront="";
        if(imageFile.value.localPath!=null){
          adharFront = (await callUploadMedia(File(imageFile.value.localPath ?? '')))?.file_name??"";
        }

        var adharBack="";
        if(imageBackAdhar.value.localPath!=null){
          adharFront = (await callUploadMedia(File(imageBackAdhar.value.localPath ?? '')))?.file_name??"";
        }

        var dlFront="";
        if(imageLicenceFont.value.localPath!=null){
          adharFront = (await callUploadMedia(File(imageLicenceFont.value.localPath ?? '')))?.file_name??"";
        }

        var dlBack="";
        if(imageLicenceFont.value.localPath!=null){
          dlBack = (await callUploadMedia(File(imageLicenceBack.value.localPath ?? '')))?.file_name??"";
        }

        var pdf="";
        if(imageLicenceFont.value.localPath!=null){
          pdf = (await callUploadMedia(File(selectedPdfFile.value?.path ?? '')))?.file_name??"";
        }
        // Get.offNamed(AppRoutes.updateDocumentRoute,arguments: {"firstname":controller.stateController.text,"lastname":controller.cityController.text,"countryCode": controller.selectedCountry.value.dialCode,
        //   "phonenumber": controller.numberController.text,"Profile":path
        // });
        Map<String, dynamic> requestModel = AuthRequestModel.editProfile(
          firstName: Get.arguments["firstname"],
          lastName:  Get.arguments["lastname"],
          countryCode: Get.arguments["countryCode"],
          phoneNumber:  Get.arguments["phonenumber"],
          profilePic: Get.arguments["Profile"],
          aadharFront: adharFront!=null?adharFront:userResponseModel.value?.data?.aadharFront,
          aadharBack: adharBack!=null?adharBack:userResponseModel.value?.data?.aadharBack,
          ambulanceNum: numberController.text,
          dlExpireDate: firstnameController.text,
          dl_num: lastnameController.text,
          hospitalDoc: pdf!=null?pdf: confimPasswordController.text,
          dlFront: dlFront!=null?dlFront:userResponseModel.value?.data?.dlFront,
          dlBack: dlBack!=null?dlBack:userResponseModel.value?.data?.dlBack,

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
    repository.editProfile(dataBody: data).then((value) async {
      if (value != null) {
        customLoader.hide();
        Get.put<ProfileController>(ProfileController()).loadProfile();
        Get.back();
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