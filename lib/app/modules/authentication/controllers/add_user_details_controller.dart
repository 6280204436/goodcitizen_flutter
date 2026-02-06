import '../../../core/utils/image_picker.dart';
import '../../../core/widgets/image_picker_dialog.dart';
import '../../../export.dart';
import '../../model/media_file_model.dart';
import '../../profile/controllers/account_detail_controller.dart';
import '../models/auth_request_model.dart';
import '../models/data_model/user_model.dart';

class AddUserDetailsController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();

  late TextEditingController emailController;
  late TextEditingController nameController;

  late FocusNode emailFocusNode;
  late FocusNode nameNode;

  RxBool isLoading = false.obs;

  RxString nameString=''.obs;
  RxString emailString=''.obs;

  Rxn<MediaFile> imageFile = Rxn();
  Rxn<MediaFile> licFront = Rxn();
  Rxn<MediaFile> licBack = Rxn();

  @override
  void onInit() {
    _getData();
    _initControllers();

    super.onInit();
  }

  void _getData() {
    if (Get.arguments != null) {}
  }

  @override
  void onReady() {
    _setData();
    super.onReady();
  }

  void pickImage() {

    showMediaPickerDialog(
      allowVideo: false,
      pickImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.gallery);
        if (file != null) {
          imageFile.value = MediaFile(localPath: file.path);
        }
      },
      takeImage: () async {
        File? file = await MediaUtils.pickImage(source: ImageSource.camera);
        if (file != null) {
          imageFile.value = MediaFile(localPath: file.path);
        }
      },
    );


  }


  void _setData() {
    if (profileDataProvider.userDataModel.value != null) {
      nameController.text = profileDataProvider.userDataModel.value?.name ?? '';
      emailController.text =
          profileDataProvider.userDataModel.value?.tempEmail ??
              profileDataProvider.userDataModel.value?.email ??
              '';

      nameString.value=nameController.text;
      emailString.value=emailController.text;

      if (profileDataProvider.userDataModel.value?.licFront != null) {
        licFront.value = MediaFile(
            networkPath: profileDataProvider.userDataModel.value?.licFront);
      }
      if (profileDataProvider.userDataModel.value?.licBack != null) {
        licBack.value = MediaFile(
            networkPath: profileDataProvider.userDataModel.value?.licBack);
      }
      if (profileDataProvider.userDataModel.value?.image != null) {
        imageFile.value = MediaFile(
            networkPath: profileDataProvider.userDataModel.value?.image);
      }
    }
  }

  validate() {
    if (formKey.currentState!.validate()) {
      _handleSubmit();
    }
  }

  bool get isEmailAlreadyVerified {
    return ((profileDataProvider.userDataModel.value?.isEmailVerify == true) &&
        (emailController.text.trim() ==
            profileDataProvider.userDataModel.value?.email));
  }

  _handleSubmit() async {
    customLoader.show(Get.context!);

    if (licFront.value?.localPath != null) {
      await callUploadMedia(File(licFront.value!.localPath!)).then(
        (value) {
          if (value != null) {
            licFront.value?.networkPath = value.file_name;
            licFront.value?.localPath = null;
          } else {
            licFront.value?.networkPath = null;
            return;
          }
        },
      );
    }

    if (licBack.value?.localPath != null) {
      await callUploadMedia(File(licBack.value!.localPath!)).then(
        (value) {
          if (value != null) {
            licBack.value?.networkPath = value.file_name;
            licBack.value?.localPath = null;
          } else {
            licBack.value?.networkPath = null;
            return;
          }
        },
      );
    }

    if (licBack.value?.networkPath == null ||
        licFront.value?.networkPath == null) {
      customLoader.hide();
      showSnackBar(message: keySomethingWrong);
      return;
    }

    if (imageFile.value?.localPath != null) {
      await callUploadMedia(File(imageFile.value!.localPath!)).then(
            (value) {
          if (value != null) {
            imageFile.value?.networkPath = value.file_name;
            imageFile.value?.localPath = null;
          } else {
            imageFile.value?.networkPath = null;
            return;
          }
        },
      );
    }

    final data = AuthRequestModel.updateProfileRequestModel(
        email: isEmailAlreadyVerified ?null: emailController.text.trim(),
        name: nameController.text.trim(),
        image: imageFile.value?.networkPath,
        licBack: licBack.value?.networkPath,
        licFront: licFront.value?.networkPath);

    repository
        .updateProfileApiCall(dataBody: data, showLoader: false)
        .then((value) {
      customLoader.hide();
      profileDataProvider.userDataModel.value?.name =
          nameController.text.trim();
      profileDataProvider.userDataModel.value?.tempEmail =
          emailController.text.trim();
      profileDataProvider.userDataModel.value?.licBack =
          licBack.value?.networkPath;
      profileDataProvider.userDataModel.value?.licFront =
          licFront.value?.networkPath;
      profileDataProvider.userDataModel.value?.image =
          imageFile.value?.networkPath;
      _saveData();
    }).onError((error, stackTrace) {
      customLoader.hide();
      showSnackBar(message: error.toString());
    });
  }

  void _saveData() {
    profileDataProvider.updateData(profileDataProvider.userDataModel.value);
    _handleNavigation();
  }

  void _handleNavigation() {
    if (isEmailAlreadyVerified) {
      Get.toNamed(AppRoutes.addVehicleDetailsRoute);
    } else {
      Get.toNamed(AppRoutes.otpVerifyRoute, arguments: {argBool: true});
    }
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initControllers() {
    emailController = TextEditingController();
    nameController = TextEditingController();

    emailFocusNode = FocusNode();
    nameNode = FocusNode();
  }

  void _disposeControllers() {
    emailController.dispose();
    nameController.dispose();

    emailFocusNode.dispose();
    nameNode.dispose();
  }
}
