import 'package:get/get.dart';

import '../../../../main.dart';
import '../models/data_model/user_model.dart';
import '../models/response_models/user_response_model.dart';

class ProfileDataProvider extends GetxController {
  Rxn<UserDataModel> userDataModel = Rxn();

  @override
  void onInit() {
    _getSavedProfileData();
    super.onInit();
  }

  void _getSavedProfileData() async {
    final data = await preferenceManager.getSavedLoginData();
    if (data != null) {
      userDataModel.value = data;
      userDataModel.refresh();
    }
  }

  void updateData(UserDataModel? model) {
    if (model != null) {
      userDataModel.value = model;
      userDataModel.refresh();
      preferenceManager.saveRegisterData(model);
    }
  }

  Future reloadProfile({bool showLoader = true}) async {
    if (showLoader) {
      customLoader.show(Get.context);
    }

    await repository.getProfileApiCall().then((value) async {
      customLoader.hide();

      if (value != null) {
        UserResponseModel userResponseModel = value;
        // updateData(userResponseModel.data);
      }
    }).onError((error, stackTrace) {
      customLoader.hide();
    });
  }
}
