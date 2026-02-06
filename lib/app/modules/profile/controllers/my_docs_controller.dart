import 'package:good_citizen/app/modules/model/media_file_model.dart';

import '../../../export.dart';
import '../../authentication/models/auth_request_model.dart';
import 'account_detail_controller.dart';

class MyDocsController extends GetxController {
  Rxn<MediaFile> licFront = Rxn();
  Rxn<MediaFile> licBack = Rxn();

  @override
  void onReady() {
    licFront.value = MediaFile(
        networkPath: profileDataProvider.userDataModel.value?.licFront);
    licBack.value = MediaFile(
        networkPath: profileDataProvider.userDataModel.value?.licBack);
    super.onReady();
  }

  handleUpdate() async {
    customLoader.show(Get.context!);

    if (licFront.value?.localPath != null) {
      await callUploadMedia(File(licFront.value!.localPath!)).then(
        (value) {
          if (value != null) {
            licFront.value?.networkPath = value.file_name;

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

    final data = AuthRequestModel.updateProfileRequestModel(
        licBack: licBack.value?.networkPath,
        licFront: licFront.value?.networkPath);

    repository
        .updateLicApiCall(dataBody: data, showLoader: false)
        .then((value) {
      customLoader.hide();
      licBack.value?.localPath = null;
      licBack.refresh();
      licFront.value?.localPath = null;
      licFront.refresh();
      profileDataProvider.userDataModel.value?.licBack =
          licBack.value?.networkPath;
      profileDataProvider.userDataModel.value?.licFront =
          licFront.value?.networkPath;
      profileDataProvider.reloadProfile(showLoader: false);
    }).onError((error, stackTrace) {
      customLoader.hide();
      showSnackBar(message: error.toString());
    });
  }
}
