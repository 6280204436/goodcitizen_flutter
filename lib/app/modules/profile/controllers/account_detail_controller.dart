import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/models/data_model/media_upload_model.dart';
import 'package:good_citizen/app/modules/profile/controllers/profile_controller.dart';

import '../../../core/utils/image_picker.dart';
import '../../../core/widgets/image_picker_dialog.dart';
import '../../authentication/models/auth_request_model.dart';
import '../../authentication/models/data_model/message_response_model.dart';
import '../../authentication/models/data_model/user_model.dart';
import '../../location_provider/native_location_services.dart';
import '../../model/media_file_model.dart';

class AccountDetailController extends GetxController {
  RxBool isImageTaken = false.obs;
  Rx<MediaFile> imageFile = MediaFile().obs;

  @override
  void onInit() {
    _getArgs();
    super.onInit();
  }

  void _getArgs() {}

  @override
  void onReady() {
    getSavedProfileData();
    super.onReady();
  }

  void getSavedProfileData() async {
    imageFile.value =
        MediaFile(networkPath: profileDataProvider.userDataModel.value?.image);
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

  Future<void> uploadImage() async {
    final path = (await callUploadMedia(File(imageFile.value.localPath ?? '')))
        ?.file_name;
    if (path == null) {
      return;
    }
    final data = AuthRequestModel.updateProfileRequestModel(image: path);
    await repository.updateProfileApiCall(dataBody: data).then((value) {
      isImageTaken.value = false;
      profileDataProvider.userDataModel.value?.image = path;
      profileDataProvider.updateData(profileDataProvider.userDataModel.value);
    }).onError((error, stackTrace) {
      imageFile.value.localPath = null;
      isImageTaken.value = false;
      showSnackBar(message: error.toString());
    });
  }

  void deleteAccount() {
    repository.deleteAccountApiCall().then((value) {
      if (value != null) {
        MessageResponseModel responseModel = value;
        showSnackBar(message: responseModel.message ?? '');
        preferenceManager.clearLoginData();
        NativeLocationServices.stopForegroundService();
        Get.offAllNamed(AppRoutes.loginRoute);
      }
    }).onError((error, stackTrace) {
      showSnackBar(message: error.toString());
    });
  }
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
