import 'package:good_citizen/app/core/utils/common_methods.dart';
import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/models/data_model/user_model.dart';
import 'package:good_citizen/app/core/utils/common_item_model.dart';
import 'package:good_citizen/app/modules/profile/controllers/profile_controller.dart';
import 'package:good_citizen/app/modules/profile/models/address_data_model.dart';

import '../../../core/utils/image_picker.dart';
import '../../../core/utils/location_detail_providers.dart';
import '../../../core/utils/location_services/location_data_model.dart';
import '../../../core/widgets/image_picker_dialog.dart';
import '../../../core/widgets/intl_phone_field/countries.dart';
import '../../../core/widgets/intl_phone_field/intl_phone_field.dart';
import '../../authentication/models/auth_request_model.dart';
import '../../authentication/models/data_model/media_upload_model.dart';
import '../../authentication/models/data_model/message_response_model.dart';
import '../../authentication/models/response_models/user_response_model.dart';
import '../../model/lat_lng_model.dart';
import '../../model/media_file_model.dart';

class EditItemController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  Rx<MediaFile> imageFile = MediaFile().obs;
  Rx<MediaFile> AdharFrontImageFile = MediaFile().obs;
  Rx<MediaFile> AdharBackImageFile = MediaFile().obs;
  RxBool isImageTaken = false.obs;
  int? editType;
  var selectedIndex = 0.obs;
  FocusNode stateFocusNode = FocusNode();
  RxString selectedState = ''.obs;
  RxString gender = ''.obs;
  final Rx<Country> selectedCountry = Country(
    name: 'India',
    code: 'IN',
    dialCode: '91',
    flag: '🇮🇳',
    nameTranslations: {'en': 'India'},
    minLength: 10,
    maxLength: 10,
  ).obs;
  FocusNode pincodeFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();
  TextEditingController messageTextController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();

  late TextEditingController emailController;
  late FocusNode emailFocusNode;

  final TextEditingController numberController = TextEditingController();
  late FocusNode phoneNode;

  late TextEditingController streetController;
  late FocusNode houseNumberNode;



  late TextEditingController cityController;
  late FocusNode cityNode;

  late TextEditingController stateController;
  late FocusNode stateNode;

  late TextEditingController genderController;
  late FocusNode genderFocusNode;

  late TextEditingController pinCodeController;
  late FocusNode pinFocusNode;

  Rx<UserResponseModel?> userResponseModel = Rx<UserResponseModel?>(null);

  RxBool isDataChanged = false.obs;
  RxBool isSavingChanges = false.obs;

  Rxn<DateTime> selectedDate = Rxn();

  List<CommonItemModel> userTypeList = [

  ];

  List<CommonItemModel> genderTypeList = [

  ];

  List<CommonItemModel> countriesList = List.generate(
      countries.length,
          (index) =>
          CommonItemModel(id: index.toString(), title: countries[index].name));


  final GlobalKey<IntlPhoneFieldState> countryPickerKey =
  GlobalKey<IntlPhoneFieldState>();

  @override
  void onInit() {

    _initControllers();

    // final country = getSelectedCountryCode();
    // selectedCountry.value = country ;

    super.onInit();
  }


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
        print(userResponseModel.value?.data?.email);
        stateController.text=userResponseModel.value?.data?.firstname??"";
        cityController.text=userResponseModel.value?.data?.lastname??"";
        numberController.text=userResponseModel.value?.data?.phonenumber??"";
        genderController.text=userResponseModel.value?.data?.gender??"Male";
        emailController.text=userResponseModel.value?.data?.email??"";
        final String code = userResponseModel.value?.data?.countrycode??'+91'; // your country code
        final Country? country = countries.firstWhereOrNull(
              (element) => element.dialCode == code,
        );

        if (country != null) {
          selectedCountry.value = country;

        }

        update();

        customLoader.hide();



    }}).onError((error, stackTrace) {

      customLoader.hide();
      update();
      debugPrint('error>>$error');
    });
  }

  void handleSubmit(Map<String, dynamic> data) {
    repository.editProfile(dataBody: data).then((value) async {
      if (value != null) {
        customLoader.hide();
        Get.put<ProfileController>(ProfileController()).loadProfile();
        Get.back();
      }
    }).onError((er, stackTrace) {
      print("$er");
      showSnackBar(message: "$er");
      customLoader.hide();
    });
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



  void AdharFrontpickImage() {
    showMediaPickerDialog(
      allowVideo: false,
      pickImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.gallery);
        if (file != null) {
          AdharFrontImageFile.value = MediaFile(localPath: file.path);
          isImageTaken.value = true;
        }
      },
      takeImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.camera);
        if (file != null) {
          AdharFrontImageFile.value = MediaFile(localPath: file.path);
          isImageTaken.value = true;
        }
      },
    );
  }





  void _initControllers() {
    emailController = TextEditingController();
    streetController = TextEditingController();
    stateController = TextEditingController();
    cityController = TextEditingController();
    pinCodeController = TextEditingController();
     genderController= TextEditingController();
    phoneNode = FocusNode();
    emailFocusNode = FocusNode();
    genderFocusNode = FocusNode();
    cityNode = FocusNode();
    stateNode = FocusNode();
    houseNumberNode = FocusNode();

    pinFocusNode = FocusNode();
  }



  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _disposeControllers() {
    emailController.dispose();
    stateController.dispose();
    cityController.dispose();
    pinCodeController.dispose();
    genderController.dispose();
    streetController.dispose();
    genderFocusNode.dispose();
    emailFocusNode.dispose();
    stateNode.dispose();
    cityNode.dispose();
    pinFocusNode.dispose();

    houseNumberNode.dispose();
  }
}
